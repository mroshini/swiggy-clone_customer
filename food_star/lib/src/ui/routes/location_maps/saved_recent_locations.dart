import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/saved_address_view_model.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/address_list_shimmer.dart';
import 'package:provider/provider.dart';

class SavedAndRecentLocationScreen extends StatefulWidget {
  @override
  _SavedAndRecentLocationScreenState createState() =>
      _SavedAndRecentLocationScreenState();
}

class _SavedAndRecentLocationScreenState
    extends State<SavedAndRecentLocationScreen> {
  @override
  Widget build(BuildContext context) {
    var addressState = Provider.of<SavedAddressViewModel>(context);

    return (addressState.state == BaseViewState.Busy)
        ? AddressListShimmer()
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(S.of(context).savedAddress,
                    style: Theme.of(context).textTheme.display1),
                verticalSizedBox(),
                ListView.builder(
                  itemCount: addressState.listOfAddress.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Container(
                    height: 50.0,
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              addressState.listOfAddress[index].addressType !=
                                      null
                                  ? (addressState.listOfAddress[index]
                                              .addressType ==
                                          1
                                      ? Icons.home
                                      : Icons.work)
                                  : Icons.location_on,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 16.0,
                              height: 8.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  addressState
                                      .listOfAddress[index].addressTypeText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(
                                        fontSize: 15,
                                      ),
                                ),
                                verticalSizedBox(),
                                Text(
                                  addressState.listOfAddress[index].address,
                                  style: Theme.of(context)
                                      .textTheme
                                      .display2
                                      .copyWith(
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            _showPopupMenu();
                          },
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSizedBox(),
//                Container(
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text(S.of(context).recentLocations,
//                          style: Theme.of(context).textTheme.display1),
//                      verticalSizedBox(),
//                      ListView.builder(
//                        itemCount: 2,
//                        shrinkWrap: true,
//                        physics: NeverScrollableScrollPhysics(),
//                        itemBuilder: (context, index) => Container(
//                          height: 35.0,
//                          margin: const EdgeInsets.symmetric(vertical: 5.0),
//                          child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Icon(
//                                Icons.home,
//                                color: Colors.grey,
//                              ),
//                              SizedBox(
//                                width: 16.0,
//                                height: 8.0,
//                              ),
//                              Flexible(
//                                child: Text(
//                                  'Backiyammal Nagar, Keelkattalai, Chennai',
//                                  style: Theme.of(context).textTheme.display2,
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
              ],
            ),
          );
//    return ChangeNotifierProvider.value(
//        value: SavedAddressViewModel(context: context),
//        child: Consumer<SavedAddressViewModel>(
//          builder: (BuildContext context, SavedAddressViewModel model,
//              Widget child) {
//
//          },
//        ));
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(150, 150, 0, 150),
      items: [
        PopupMenuItem<String>(
            child: Text(
              "Edit",
              style: Theme.of(context).textTheme.display2,
            ),
            value: '1'),
        PopupMenuItem<String>(
            child: Text(
              "Delete",
              style: Theme.of(context).textTheme.display2,
            ),
            value: '2'),
      ],
      elevation: 8.0,
    );
  }
}
