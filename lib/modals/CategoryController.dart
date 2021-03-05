import 'package:flutter/material.dart';
class CategoryController extends ChangeNotifier{

  String selectedCategory;
  List<String> categoryList=["Create new Category"];

  setSelectedCategory({String to}){
    selectedCategory=to;
    notifyListeners();
  }

  setCategoryList(List<String> list){
    list.insert(0, 'Create new Category');
    categoryList=list;
    notifyListeners();
  }

  addToCategory({String newCategory}){
    categoryList.add(newCategory);
    notifyListeners();
  }

}