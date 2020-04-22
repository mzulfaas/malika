import 'package:air_bizz/base/base-state.dart';
import 'package:air_bizz/feature/main/dashboard/monitoring-stock/monitoring-stock-presenter.dart';
import 'package:air_bizz/model/monitoring-stock-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonitoringStockPage extends BaseStatefulWidget {

  final bool isBuyer;
  final String buyerId;
  MonitoringStockPage({this.isBuyer = true, this.buyerId});

  @override
  _MonitoringStockPageState createState() => _MonitoringStockPageState();
}

class _MonitoringStockPageState extends BaseState<MonitoringStockPage,MonitoringStockPresenter> implements MonitoringStockContract {

  String draft = "Draft";
  List<MonitoringStockModel> list = [];
  List<MonitoringStockModel> oldList = [];
  int pageTotal = 0;
  int totalItem;  int page = 1;
  ScrollController _scrollController = new ScrollController();

  @override
  fetchMonitoringStock(List<MonitoringStockModel> unit, int pageTotal, int totalItem) {
    print("ini data ${unit.length}");
    List<MonitoringStockModel> current = list;
    current.addAll(unit);
    setState(() {
      this.list = current;
      this.oldList = current;
      this.pageTotal = pageTotal;
      this.totalItem = totalItem;
    });
    return list;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
//        print('ini page total: $pageTotal ${page++}' );
        // if we are at the bottom of the page
        if (page < pageTotal) presenter.getListDraft(page++,widget.buyerId);
//
//        for (var c = 0; c < 3; c++){
//          presenter.getListDraft(c + 1);
//          page = c;
//        }
      }
    });
  }

  @override
  void initMvp() {
    // TODO: implement initMvp
    super.initMvp();
    presenter = MonitoringStockPresenter();
    presenter.setView(this);
    presenter.getListDraft(0,widget.buyerId);
  }

  @override
  showError(String message) {
    // TODO: implement showError
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Monitoring Stock", style: TextStyle(
          color: Colors.black
        ),),
        leading: InkWell(
          onTap: (){
            pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: isOnProgress? Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 45,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(
                  horizontal: 7,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.search,
                        size: 20.0,
                        color: Colors.grey,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        child: TextField(
                          onChanged: (inputValue) {
                            inputValue = inputValue.toLowerCase();
                            list = oldList;
                            List<MonitoringStockModel> sip;
                            if (widget.isBuyer) {
                              sip = list
                                  .where((eachItem) =>
                              eachItem.companyDesc
                                  .toString()
                                  .toLowerCase()
                                  .contains(inputValue) ||
                                  eachItem.id
                                      .toString()
                                      .toLowerCase()
                                      .contains(inputValue) ||
                                  eachItem.plantDesc
                                      .toLowerCase()
                                      .contains(inputValue))
                                  .toList();
              