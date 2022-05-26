import 'dart:io';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:logger/logger.dart';

final cookieRegex = RegExp(r'(?<=^|\S,).*?(?=$|,\S)');

class FederatedHttpClient extends http.BaseClient {
  final _client = http.Client();
  final cookies = CookieJar();

  final String _username;
  final String _password;

  bool _gotCorrectMoodleSession = false;
  int shibindexsFound = 0;

  FederatedHttpClient(this._username, this._password);

  Future<List<http.Response>> _getUrlWithRedirects(Uri url) async {
    final responses = List<http.Response>.empty(growable: true);

    var request = http.Request('GET', url);
    request.followRedirects = false;

    var response = await http.Response.fromStream(await send(request));
    responses.add(response);

    var currentUrl = url;
    while (response.isRedirect) {
      final location = response.headers['location'];

      if (location != null) {
        currentUrl = currentUrl.resolve(location);

        request = http.Request('GET', currentUrl);
        request.followRedirects = false;
        response = await http.Response.fromStream(await send(request));
        responses.add(response);
      }
    }

    return responses;
  }

  Future<void> login(String url) async {
    return loginUrl(Uri.parse(url));
  }

  Future<void> loginUrl(Uri url) async {
    final responses = await _getUrlWithRedirects(url);

    if (responses.length <= 1) {
      // For federated authentication to be sucessful,
      // there needs to be at least a redirect, at the start, from the
      // Service Provider (eg. Moodle) to the Identity Provider
      // (eg. Shibboleth aka AAI)
      throw ArgumentError(
          'The provided url is not a valid authentication endpoint');
    }

    var lastResponse = responses.last;
    var lastResponseLocation = lastResponse.request.url;

    if (lastResponseLocation.host == url.host) {
      // There was an immediate redirect by Shibboleth and,
      // as such, authentication is completed and successful
      if (lastResponse.statusCode != 200) {
        throw StateError('An unknown error occured during the login process');
      }

      return;
    }
    String title;
    do {
      var document = html.parse(lastResponse.body);
      var title = document.querySelector('head > title')?.text;
      if (title == 'Web Login Service') {
        final authFields = {
          'username': _username,
          'password': _password,
          'btnLogin': '',
        };

        final formElement = document.querySelector('form');

        final formAction = formElement.attributes['action'];
        final formMethod = formElement.attributes['method'];

        final Map<String, String> formData = {};
        for (var entry in authFields.entries) {
          final element = formElement.querySelector('#${entry.key}');
          final name = element.attributes['name'];

          formData[name] = entry.value;
        }
        final formElements =
            formElement.querySelectorAll('input[type=\"hidden\"]');

        for (var element in formElements) {
          final name = element.attributes['name'];
          final value = element.attributes['value'] ?? '';
          formData[name] = value;
        }
        formData['j_username'] = _username;
        formData['j_password'] = _password;

        final loginRequest =
            http.Request(formMethod, lastResponseLocation.resolve(formAction));

        loginRequest.bodyFields = formData;

        var loginResponse =
            await http.Response.fromStream(await send(loginRequest));

        lastResponse = loginResponse;
        lastResponseLocation = loginRequest.url;

        // Because there is a very high change we are submitting a POST request,
        // we need to handle the possibility that the client can (and does) send
        // a 302 status code with a redirect. By default, the user agent must
        // specify its behaviour in those situations.
        //
        // See: https://github.com/dart-lang/http/issues/157#issuecomment-417639249
        if (loginResponse.statusCode == 302) {
          final location = loginResponse.headers['location'];
          final loginResponses =
              await _getUrlWithRedirects(loginRequest.url.resolve(location));

          lastResponse = loginResponse = loginResponses.last;
          lastResponseLocation = lastResponse.request.url;
        }

        document = html.parse(loginResponse.body);
        lastResponse = loginResponse;
        title = document.querySelector('head > title')?.text;
        if (title == 'Web Login Service') {
          throw ArgumentError('The provided username and password are invalid');
        }
      }

      if (title == 'Information Release') {
        throw StateError('An information release was requested');
      }
      if (title != null) {
        if (!title.contains('Web Login Service')) {
          break;
        }
      }

      final formElement = document.querySelector('form');

      final formAction = formElement.attributes['action'];
      final formMethod = formElement.attributes['method'];

      final formElements =
          formElement.querySelectorAll('input[type=\"hidden\"]');

      final Map<String, String> formData = {};
      for (var element in formElements) {
        final name = element.attributes['name'];
        final value = element.attributes['value'] ?? '';
        formData[name] = value;
      }
      formData['j_username'] = _username;
      formData['j_password'] = _password;

      final finalRequest =
          http.Request(formMethod, lastResponseLocation.resolve(formAction));
      finalRequest.bodyFields = formData;

      var finalResponse =
          await http.Response.fromStream(await send(finalRequest));

      if (finalResponse.statusCode == 302) {
        final location = finalResponse.headers['location'];
        finalResponse =
            (await _getUrlWithRedirects(finalRequest.url.resolve(location)))
                .last;
      }

      if (finalResponse.statusCode != 200) {
        throw StateError('Something went wrong');
      }
      lastResponse = finalResponse;
      document = html.parse(lastResponse.body);
      title = document.querySelector('title').text;

      if (!title.contains('Web Login Service')) continue;
    } while (title != 'Web Login Service');
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request,
      {bloat = false}) async {
    final sentCookies = await cookies.loadForRequest(
        bloat ? Uri.parse('https://moodle.up.pt/my') : request.url);

    if (sentCookies.isNotEmpty) {
      final cookieHeader =
          sentCookies.map((e) => '${e.name}=${e.value}').join('; ') + ';';
      request.headers['Cookie'] = cookieHeader;
    }

    final response = await _client.send(request);

    final receivedCookies = response.headers['set-cookie'];

    if (receivedCookies != null) {
      if (_gotCorrectMoodleSession && false) {
        if (receivedCookies.contains('MoodleSession')) {
          return response;
        }
      }
      if (request.url.toString() ==
          'https://moodle.up.pt//auth/shibboleth/index.php') {
        //It's this cookie
        shibindexsFound += 1;
        if (shibindexsFound == 2) {
          _gotCorrectMoodleSession = true;
        }
      }

      final parsedCookies = cookieRegex
          .allMatches(receivedCookies)
          .map((e) => e.group(0))
          .where((element) => element != null)
          .cast<String>()
          .map((e) => Cookie.fromSetCookieValue(e))
          .toList();

      await cookies.saveFromResponse(request.url, parsedCookies);
    }

    return response;
  }

  void printCookies(List<Cookie> cookies) {
    String cookiesStr = '';
    for (Cookie cookie in cookies) {
      cookiesStr += cookie.name + '=' + cookie.value + ';';
    }
    Logger().i('====> printCookies = ' + cookiesStr);
  }

  Future<http.Response> request(String url,
      {String body = null,
      String method = 'GET',
      String contentType = 'text/html'}) async {
    //final loginRequest =
    //     http.Request('GET', Uri.parse('https://eotkqufho5xnoq3.m.pipedream.net'));
    final request = http.Request(method, Uri.parse(url));
    request.followRedirects = false;
    if (body != null) {
      request.body = body;
      request.headers['Content-Type'] = contentType;
    }
    final http.Response response =
        await http.Response.fromStream(await send(request, bloat: false));

    return response;
  }
}
