import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:royal_advisor/customExceptions.dart';
import 'package:royal_advisor/models/questionListModel.dart';
import 'package:royal_advisor/models/questionModel.dart';

class ApiCalls {
  Future fetchQuestionList() async {
    final url =
        Uri.parse("https://royal-advisor-api.herokuapp.com/question/all");
    late final response;
    try {
      response = await http.get(url);
    } on SocketException catch (e) {
      print(e);
      return NoInternetException('No Internet Exception');
    }catch(e){
      print(e);
      return Exception('Some error occurred, Can\'t get response from server');
    }
    print('fetch questions list');
    if (response.statusCode == 200) {
      if (response.body.length <= 0) {
        return Exception('No Response from the Server');
      }
      print(response.body);
      final parsed = json.decode(response.body) as Map<String, dynamic>;
      print(parsed);
      if (parsed["questions"] == null) {
        return Exception('No Questions Found on Server');
      }
      try {
        var temp = parsed["questions"]
            .map<QuestionListItem>((json) => QuestionListItem.fromJson(json))
            .toList();
        print(temp);
        print('end fetch questions list');
        return temp;
      } catch (e) {
        print(e);
        return Exception('Some Error Occurred, Please try Again');
      }
    } else {
      return Exception('Unable to fetch data from the REST API');
    }
  }

  Future fetchQuestion(String id) async {
    final url = Uri.parse(
        "https://royal-advisor-api.herokuapp.com/question/single/${id}");
    late final response;
    try{
      response = await http.get(url);
    } on SocketException catch (e) {
      print(e);
      return NoInternetException('No Internet Exception');
    }catch(e){
      print(e);
      return Exception('Some error occurred, Can\'t get response from server');
    }
    print('fetch question');
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body) as Map<String, dynamic>;
      print(parsed);
      if (parsed["question"] == null) {
        return Exception('Question not found on Server');
      }
      var temp = Question.fromJson(parsed['question']);
      print(temp);
      print('end fetch question');
      return temp;
    } else {
      print('no 200 status');
      return Exception('Unable to fetch data from the REST API');
    }
  }
}
