import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/theme_changer.dart';
import 'package:foodstar/src/core/provider_viewmodels/home_restaurant_list_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/sort_and_filter_shimmer.dart';
import 'package:provider/provider.dart';

class SortFilterScreen extends StatefulWidget {
  @override
  _SortFilterScreenState createState() => _SortFilterScreenState();
}

class _SortFilterScreenState extends State<SortFilterScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        maxChildSize: 1.0,
        initialChildSize: .50,
        minChildSize: .50,
        builder: (context, scrollController) {
          return Consumer2<HomeRestaurantListViewModel, ThemeManager>(builder:
              (BuildContext context, HomeRestaurantListViewModel model,
                  ThemeManager theme, Widget child) {
            return Container(
              color: theme.darkMode ? Colors.black : Colors.white,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              dragIcon(),
                              verticalSizedBox(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(S.of(context).sortAndFilters,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subhead),
                                  ),
                                ],
                              ),
                              verticalSizedBox(),
                              model.state == BaseViewState.Busy &&
                                      model.filter.length == 0
                                  ? SortAndFilterShimmer()
                                  : Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: model.filter.length,
                                                itemBuilder: (context, index) =>
                                                    InkWell(
                                                  onTap: () {
                                                    model.updateIndex(index);
                                                  },
                                                  child: Consumer<ThemeManager>(
                                                    builder: (builder, theme,
                                                        child) {
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: theme.darkMode
                                                              ? (model.sortAndFilterParentSelectedIndex ==
                                                                      index)
                                                                  ? Colors
                                                                      .grey[500]
                                                                  : Colors
                                                                      .grey[800]
                                                              : (model.sortAndFilterParentSelectedIndex ==
                                                                      index)
                                                                  ? Colors.white
                                                                  : Colors.grey[
                                                                      200],
                                                          border: Border(
                                                            left: BorderSide(
                                                              color: theme
                                                                      .darkMode
                                                                  ? (model.sortAndFilterParentSelectedIndex ==
                                                                          index)
                                                                      ? appColor
                                                                      : Colors.grey[
                                                                          800]
                                                                  : (model.sortAndFilterParentSelectedIndex ==
                                                                          index)
                                                                      ? appColor
                                                                      : Colors.grey[
                                                                          200],
                                                              width: 5,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 45.0,
                                                        child:
                                                            FilterListItemView(
                                                          title: model
                                                              .filter[index]
                                                              .filterName,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: SubSortFilterView(
                                              parentIndex: selectedIndex,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: FlatButton(
                          child: Text(
                            S.of(context).clearAll,
                            style:
                                Theme.of(context).textTheme.display1.copyWith(
                                      color: Theme.of(context).accentColor,
                                    ),
                          ),
                          onPressed: () {
                            model.clearAllFilters();
                            model.updateSortAndFilterMap(
                              sortBy: "",
                              rating: "",
                              cuisines: "",
                            );
                            model.getRestaurantDataApiRequest(
                              firstStatus: "1",
                              fromFilter: true,
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            child: Text(
                              S.of(context).apply,
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(color: Colors.white),
                            ),
                            onPressed: () {
                              //model.showSortFilter(false);
                              // navigateToHome();
                              model.getRestaurantDataApiRequest(
                                  firstStatus: "1", fromFilter: true);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });

//    return MediaQuery(
//      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//      child: Container(
//        height: MediaQuery.of(context).size.height * 0.75,
//
//      ),
//    );
  }
}

class FilterListItemView extends StatelessWidget {
  final String title;

  const FilterListItemView({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(title, style: Theme.of(context).textTheme.display2),
            ),
          ),
        ),
        Container(
          color: Colors.grey[300],
          height: 1.0,
        )
      ],
    );
  }
}

class SubSortFilterView extends StatefulWidget {
  final int parentIndex;

  const SubSortFilterView({Key key, this.parentIndex}) : super(key: key);

  @override
  _SubSortFilterViewState createState() =>
      _SubSortFilterViewState(parentIndex: parentIndex);
}

class _SubSortFilterViewState extends State<SubSortFilterView> {
  TextEditingController _sortEditingController;
  int _selectDeliveryOption = 0;
  final int parentIndex;
  List<String> mapFilter = ["1", "0", "0"];

  _SubSortFilterViewState({this.parentIndex});

  @override
  void initState() {
    super.initState();

//    Provider.of<HomeRestaurantListViewModel>(context, listen: false)
//        .getSortFilterFromPref();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeRestaurantListViewModel>(
      builder: (BuildContext context, HomeRestaurantListViewModel model,
          Widget child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              verticalSizedBox(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
//                    Text(
//                      'Top Picks',
//                      style: Theme.of(context).textTheme.display2.copyWith(
//                            color: Colors.grey,
//                          ),
//                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: model
                          .filter[model.sortAndFilterParentSelectedIndex]
                          .filterValues
                          .length,
                      itemBuilder: (context, index) => Ink(
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: Radio(
                                  value: index,
                                  groupValue: model
                                              .sortAndFilterParentSelectedIndex ==
                                          0
                                      ? model.radioGroupValueOne
                                      : model.sortAndFilterParentSelectedIndex ==
                                              1
                                          ? model.radioGroupValueTwo
                                          : model.radioGroupValueThree,
                                  activeColor: appColor,
                                  onChanged: (value) {
                                    var sortBy =
                                        model.loadSortAndFilterMap.sortBy;
                                    var rating =
                                        model.loadSortAndFilterMap.rating;
                                    var cuisines =
                                        model.loadSortAndFilterMap.cuisines;
                                    if (model
                                            .sortAndFilterParentSelectedIndex ==
                                        0) {
                                      model.updateRadioGroupValueOne(value);
                                      sortBy = model
                                          .filter[model
                                              .sortAndFilterParentSelectedIndex]
                                          .filterValues[index]
                                          .name
                                          .toString();
                                    } else if (model
                                            .sortAndFilterParentSelectedIndex ==
                                        1) {
                                      model.updateRadioGroupValueTwo(value);
                                      rating = model
                                          .filter[model
                                              .sortAndFilterParentSelectedIndex]
                                          .filterValues[index]
                                          .name
                                          .toString();
                                    } else if (model
                                            .sortAndFilterParentSelectedIndex ==
                                        2) {
                                      model.updateRadioGroupValueThree(value);
                                      showLog(
                                          "updateRadioGroupValueThree1--${value}");
                                      cuisines = model
                                          .filter[model
                                              .sortAndFilterParentSelectedIndex]
                                          .filterValues[index]
                                          .name
                                          .toString();
                                      showLog(
                                          "updateRadioGroupValueThree1--${cuisines}");
                                    }
                                    model.updateSortAndFilterMap(
                                      sortBy: sortBy,
                                      rating: rating,
                                      cuisines: cuisines,
                                    );
                                  },
                                ),
                              ),
                              new Text(
                                model
                                    .filter[
                                        model.sortAndFilterParentSelectedIndex]
                                    .filterValues[index]
                                    .name,
                                style: Theme.of(context)
                                    .textTheme
                                    .display2
                                    .copyWith(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
//    return BaseWidget<HomeRestaurantListViewModel>(
//        model: HomeRestaurantListViewModel(context: context),
//        onModelReady: (model) => model.getSortFilterFromPref(),
//        builder: (BuildContext context, HomeRestaurantListViewModel model,
//            Widget child) {
//
//        });
  }
}
