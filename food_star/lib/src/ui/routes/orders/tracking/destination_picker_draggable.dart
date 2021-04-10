import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/routes/orders/tracking/map_view_modal.dart';
import 'package:foodstar/src/utils/google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

class DestinationPickerDraggable extends StatefulWidget {
  @override
  _DestinationPickerDraggableState createState() =>
      _DestinationPickerDraggableState();
}

class _DestinationPickerDraggableState
    extends State<DestinationPickerDraggable> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.15,
      maxChildSize: 0.60,
      builder: (BuildContext context, ScrollController scrollController) {
        final model = Provider.of<MapViewModel>(context);

        return SingleChildScrollView(
          controller: scrollController,
          child: Card(
            elevation: 12.0,
            margin: const EdgeInsets.all(0),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 12),
                  Container(
                    height: 5,
                    width: 36,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Text(
                          'Hello,Jagath!',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Text(
                          'Where do you want to go?',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: textFieldBackgroundContainer(
                            isFieldFocused:
                                isFocused(model.startPointFocusNode),
                            context: context,
                            child: TextField(
                              focusNode: model.startPointFocusNode,
                              style: Theme.of(context).textTheme.display2,
                              controller: model.startPointController,
                              decoration: textFiledInputDecoration(
                                  isFieldFocused: true,
                                  context: context,
                                  hintText: 'Where to pick you up?',
                                  suffixIcon:
                                      isFocused(model.startPointFocusNode)
                                          ? Icon(
                                              Icons.cancel,
                                              color: Colors.grey,
                                            )
                                          : null),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 20),
                        child: textFieldBackgroundContainer(
                            isFieldFocused: isFocused(model.endPointFocusNode),
                            context: context,
                            child: TextField(
                              onTap: () async {
                                Prediction p = await PlacesAutocomplete.show(
                                    context: context,
                                    apiKey: kGoogleApiKey,
                                    mode: Mode.overlay,
                                    // Mode.fullscreen
                                    language: "en",
                                    components: [
                                      new Component(Component.country, "In")
                                    ]);
                                model.endPointController.text =
                                    p.description.toString();
                                model.sendRequest(
                                    p.description.characters.toString());
                              },
                              style: Theme.of(context).textTheme.display2,
                              focusNode: model.endPointFocusNode,
                              controller: model.endPointController,
                              onSubmitted: (value) {
                                model.sendRequest(value);
                              },
                              decoration: textFiledInputDecoration(
                                  isFieldFocused:
                                      isFocused(model.endPointFocusNode),
                                  context: context,
                                  hintText: 'Where do you want to go?',
                                  suffixIcon: isFocused(model.endPointFocusNode)
                                      ? Icon(
                                          Icons.cancel,
                                          color: Colors.grey,
                                        )
                                      : null),
                            )),
                      ),
//                      ListView.builder(
//                          shrinkWrap: true,
//                          physics: NeverScrollableScrollPhysics(),
//                          itemCount: myPlacesListData.length,
//                          itemBuilder: (context, index) {
//                            return InkWell(
//                              /*onTap: () {
//                                Navigator.pushNamed(context,
//                                    mapOriginDestinationRouteNavigationPath);
//                              },*/
//                              child: ListTile(
//                                leading: myPlacesListData[index].leadingIcon,
//                                title: Padding(
//                                  padding: const EdgeInsets.only(
//                                      left: 8.0, bottom: 8),
//                                  child: Text(
//                                    myPlacesListData[index].title,
//                                    style: Theme.of(context)
//                                        .textTheme
//                                        .headline6
//                                        .copyWith(fontWeight: FontWeight.bold),
//                                  ),
//                                ),
//                                subtitle: Padding(
//                                  padding: const EdgeInsets.only(left: 8.0),
//                                  child: Text(
//                                    myPlacesListData[index].subTitle,
//                                    style:
//                                        Theme.of(context).textTheme.subtitle1,
//                                  ),
//                                ),
//                              ),
//                            );
//                          }),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget textFieldBackgroundContainer(
      {Widget child,
      @required BuildContext context,
      bool isFieldFocused = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isFieldFocused ? Colors.grey : Colors.grey[100],
        ),
        color: isFieldFocused ? Colors.white : Colors.grey[100],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }

  InputDecoration textFiledInputDecoration(
      {BuildContext context,
      String labelText,
      suffixIcon,
      bool isFieldFocused = false,
      prefixIcon,
      hintText}) {
    return InputDecoration(
      border: InputBorder.none,
      labelText: labelText != null ? labelText : null,
      hintText: hintText != null ? hintText : null,
      hintStyle: Theme.of(context).textTheme.subtitle1.copyWith(
            color: appColor,
          ),
      labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
            color: isFieldFocused ? appColor : blue,
          ),
      suffixIcon: suffixIcon != null ? suffixIcon : null,
      prefixIcon: prefixIcon != null ? prefixIcon : null,
      counterText: '',
    );
  }

  bool isFocused(FocusNode focusNode) {
    showLog("Focus: " + focusNode.hasFocus.toString());
    return focusNode.hasFocus;
  }
}
