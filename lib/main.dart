import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '水果机',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: '水果机'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Player {
  String path;
  int tag;

  Player(this.path, this.tag);
}

class _MyHomePageState extends State<MyHomePage> {
  //列表项-每个列表项打乱随机展示
  final List<Player> _list = [
    Player("images/1.png", 1),
    Player("images/2.png", 2),
    Player("images/3.png", 3),
    Player("images/4.png", 4),
    Player("images/5.png", 5),
    Player("images/6.png", 6),
    Player("images/7.png", 7),
    Player("images/8.png", 8),
  ];

  late Timer _timer;
  final random = Random();

  //几局能赢
  var playCount = 1;
  final int _winCount = 3;

  //获取随机数
  int getRandomInt(int min, int max) {
    return random.nextInt((max - min).floor()) + min;
  }

  //三者中获取最大数
  int getMaxInThree(int one, int two, int three) {
    if (one > two && one > three) {
      return one;
    }
    if (two > one && two > three) {
      return two;
    }
    if (three > one && three > two) {
      return three;
    }
    return -1;
  }

  //两者中获取最大数
  int getMaxInTwo(int one, int two) {
    if (one > two) {
      return one;
    }
    if (one < two) {
      return two;
    }
    return one;
  }

  //打乱数组
  shuffle(List arr) {
    List newArr = [];
    newArr.addAll(arr);
    for (var i = 1; i < newArr.length; i++) {
      var j = getRandomInt(0, i);
      var t = newArr[i];
      newArr[i] = newArr[j];
      newArr[j] = t;
    }
    return newArr;
  }

  //控制按钮是否可点击
  late bool _isBtnCanClick;

  //三项列表
  final List<Player> _listOne = [];
  final List<Player> _listTwo = [];
  final List<Player> _listThree = [];

  //列表滚动停止位置
  var _listOneIndex = 0;
  var _listTwoIndex = 0;
  var _listThreeIndex = 0;

  //上一个滚动到的位置
  var _listOnePreIndex = 0;
  var _listTwoPreIndex = 0;
  var _listThreePreIndex = 0;

  final FixedExtentScrollController _fixedExtentScrollControllerOne =
      FixedExtentScrollController();
  final FixedExtentScrollController _fixedExtentScrollControllerTwo =
      FixedExtentScrollController();
  final FixedExtentScrollController _fixedExtentScrollControllerThree =
      FixedExtentScrollController();

  //开始滚动
  void _doScroll() {
    if (_isBtnCanClick) {
      _isBtnCanClick = false;
      //先滚动起来
      // _fixedExtentScrollControllerOne.jumpToItem(_listOneIndex);
      // _fixedExtentScrollControllerTwo.jumpToItem(_listTwoIndex);
      // _fixedExtentScrollControllerThree.jumpToItem(_listThreeIndex);
      //计算合适的滚动位置
      _listOneIndex = getFitLocation(_listOnePreIndex, _listOne);
      _listTwoIndex = getFitLocation(_listTwoPreIndex, _listTwo);
      _listThreeIndex = getFitLocation(_listThreePreIndex, _listThree);
      //给出赢的几率
      if (playCount != 0 && playCount % _winCount == 0) {
        var max = getMaxInThree(_listOneIndex, _listTwoIndex, _listThreeIndex);
        if (max == -1) {
          max = getMaxInTwo(_listOneIndex, _listTwoIndex);
        }
        var winTag = 1;
        if (max == _listOneIndex) {
          _listOneIndex = max;
          winTag = _listOne[_listOneIndex].tag;
          for (int i = _listTwo.length - 4; i > 0; i--) {
            if ((_listTwo[i].tag == winTag) &&
                (_listTwoIndex > _listTwoPreIndex) &&
                (_listTwoIndex - _listTwoPreIndex > 4)) {
              _listTwoIndex = i;
              break;
            }
          }
          for (int i = _listThree.length - 4; i > 0; i--) {
            if ((_listThree[i].tag == winTag) &&
                (_listThreeIndex > _listThreePreIndex) &&
                (_listThreeIndex - _listThreePreIndex > 4)) {
              _listThreeIndex = i;
              break;
            }
          }
        } else if (max == _listTwoIndex) {
          _listTwoIndex = max;
          winTag = _listTwo[_listTwoIndex].tag;
          for (int i = _listOne.length - 4; i > 0; i--) {
            if ((_listOne[i].tag == winTag) &&
                (_listOneIndex > _listOnePreIndex) &&
                (_listOneIndex - _listOnePreIndex > 4)) {
              _listOneIndex = i;
              break;
            }
          }
          for (int i = _listThree.length - 4; i > 0; i--) {
            if ((_listThree[i].tag == winTag) &&
                (_listThreeIndex > _listThreePreIndex) &&
                (_listThreeIndex - _listThreePreIndex > 4)) {
              _listThreeIndex = i;
              break;
            }
          }
        } else {
          _listThreeIndex = max;
          winTag = _listThree[_listThreeIndex].tag;
          for (int i = _listOne.length - 4; i > 0; i--) {
            if ((_listOne[i].tag == winTag) &&
                (_listOneIndex > _listOnePreIndex) &&
                (_listOneIndex - _listOnePreIndex > 4)) {
              _listOneIndex = i;
              break;
            }
          }
          for (int i = _listTwo.length - 4; i > 0; i--) {
            if ((_listTwo[i].tag == winTag) &&
                (_listTwoIndex > _listTwoPreIndex) &&
                (_listTwoIndex - _listTwoPreIndex > 4)) {
              _listTwoIndex = i;
              break;
            }
          }
        }
      }

      _fixedExtentScrollControllerOne.animateToItem(_listOneIndex,
          duration: const Duration(seconds: 4), curve: Curves.ease);
      _fixedExtentScrollControllerTwo.animateToItem(_listTwoIndex,
          duration: const Duration(seconds: 4), curve: Curves.ease);
      _fixedExtentScrollControllerThree.animateToItem(_listThreeIndex,
          duration: const Duration(seconds: 4), curve: Curves.ease);
      _startTimer();

      ++playCount;

      setState(() {
        _listOnePreIndex = _listOneIndex;
        _listTwoPreIndex = _listTwoIndex;
        _listThreePreIndex = _listThreeIndex;
      });
    }
  }

  ///获取随机位置
  int getFitLocation(int preIndex, List<Player> list) {
    var currIndex = getRandomInt(0, list.length);
    if (isFitLocation(currIndex, preIndex, list)) {
      return currIndex;
    }
    return getFitLocation(preIndex, list);
  }

  ///是否是满意的随机数
  bool isFitLocation(int currIndex, int preIndex, List<Player> list) {
    if (currIndex > 5 && currIndex > preIndex && currIndex < list.length - 4) {
      return true;
    }
    return false;
  }

  ///开始倒计时
  void _startTimer() {
    const duration = Duration(seconds: 4);
    callback(timer) => {
          setState(() {
            stopTimer();
          })
        };
    _timer = Timer.periodic(duration, callback);
    // play();
  }

  ///停止倒计时
  void stopTimer() {
    checkIsSame();
    _isBtnCanClick = true;
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _isBtnCanClick = true;
    for (int i = 0; i < 50; i++) {
      var index1 = getRandomInt(0, _list.length);
      _listOne.add(_list[index1]);
      var index2 = getRandomInt(0, _list.length);
      _listTwo.add(_list[index2]);
      var index3 = getRandomInt(0, _list.length);
      _listThree.add(_list[index3]);
    }
    // _listOne = shuffle(_listOne);
    // _listTwo = shuffle(_listTwo);
    // _listThree = shuffle(_listThree);
    _fixedExtentScrollControllerOne.addListener(() {
      var offset = _fixedExtentScrollControllerOne.offset;
      if (_listOneIndex * 40 == offset.toInt()) {
        // checkIsSame();
        completeInfiniteList(_listOneIndex, _listOne);
      }
    });
    _fixedExtentScrollControllerTwo.addListener(() {
      var offset = _fixedExtentScrollControllerTwo.offset;
      if (_listTwoIndex * 40 == offset.toInt()) {
        // checkIsSame();
        completeInfiniteList(_listTwoIndex, _listTwo);
      }
    });
    _fixedExtentScrollControllerThree.addListener(() {
      var offset = _fixedExtentScrollControllerThree.offset;
      if (_listThreeIndex * 40 == offset.toInt()) {
        // checkIsSame();
        completeInfiniteList(_listThreeIndex, _listThree);
      }
    });
  }

  //判断是否一致
  void checkIsSame() {
    if (kDebugMode) {
      print(
          "checkIsSame() oneIndex= $_listOneIndex, twoIndex= $_listTwoIndex, threeIndex= $_listThreeIndex");
    }
    var tag1 = _listOne[_listOneIndex].tag;
    var tag2 = _listTwo[_listTwoIndex].tag;
    var tag3 = _listThree[_listThreeIndex].tag;
    if (tag1 == tag2 && tag2 == tag3) {
      playCount = 0;
      Fluttertoast.showToast(
          msg: "Winner",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    // _listOnePreIndex -= _listOneIndex;
    // if (_listOnePreIndex < 0) _listOnePreIndex = 0;
    // _listTwoPreIndex -= _listTwoIndex;
    // if (_listTwoPreIndex < 0) _listTwoPreIndex = 0;
    // _listThreePreIndex -= _listThreeIndex;
    // if (_listThreePreIndex < 0) _listThreePreIndex = 0;

    // _listOneIndex = 2;
    // _listTwoIndex = 2;
    // _listThreeIndex = 2;
    if (kDebugMode) {
      print(
          "checkIsSame() _listOnePreIndex= $_listOnePreIndex, _listTwoPreIndex= $_listTwoPreIndex, _listThreePreIndex= $_listThreePreIndex");
    }
  }

  ///实现无限循环滚动列表
  ///index [6, list.length-3]
  void completeInfiniteList(int index, List<Player> list) {
    //把前index个列表项移除并加到列表后面
    // if (index > 2) {
    //   var removeList = list.sublist(0, index - 2);
    //   list.removeRange(0, index - 2);
    //   list.addAll(removeList);
    // } else {
    var removeList = list.sublist(0, index);
    // list.removeRange(0, index);
    list.addAll(removeList);
    // }
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _fixedExtentScrollControllerOne.dispose();
    _fixedExtentScrollControllerTwo.dispose();
    _fixedExtentScrollControllerThree.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screeW = size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage("images/title_slot.png"),
              width: 200,
            ),
            SizedBox(
              width: screeW,
              height: 300,
              child: Stack(
                children: [
                  Image(
                    image: const AssetImage("images/content_bg.png"),
                    width: screeW,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //三个并排列表
                      _fruitWidget(
                          _listOne, screeW, _fixedExtentScrollControllerOne),
                      _fruitWidget(
                          _listTwo, screeW, _fixedExtentScrollControllerTwo),
                      _fruitWidget(_listThree, screeW,
                          _fixedExtentScrollControllerThree),
                    ],
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: _doScroll,
              child: const Image(
                image: AssetImage("images/start.png"),
                width: 200,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _fruitWidget(List<Player> list, var screenW, var controller) {
    return SizedBox(
      width: (screenW - 200) / 3,
      child: ListWheelScrollView.useDelegate(
          itemExtent: 40,
          diameterRatio: 1,
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) => Image(
              image: AssetImage(list[index].path),
              width: 30,
              height: 30,
            ),
            childCount: list.length,
          )),
    );
  }
}
