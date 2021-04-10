import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/validation.dart';

class AddDishNotesScreen extends StatefulWidget {
  final String itemNotes;
  final int foodID;

  // final RestaurantDetailsViewModel model;
  final SearchViewModel searchViewModel;
  final CartBillDetailViewModel cartBillDetailViewModel;
  final int fromWhere;
  final int parentIndex;
  final int childIndex;
  final BuildContext mContext;

  AddDishNotesScreen({
    this.itemNotes,
    //  this.model,
    this.searchViewModel,
    this.cartBillDetailViewModel,
    this.fromWhere,
    this.foodID,
    this.parentIndex,
    this.childIndex,
    this.mContext,
  });

  @override
  _AddDishNotesScreenState createState() => _AddDishNotesScreenState(
        //  model: model,
        cartBillDetailViewModel: cartBillDetailViewModel,
        searchViewModel: searchViewModel,
        foodID: foodID,
        parentIndex: parentIndex,
        childIndex: childIndex,
      );
}

class _AddDishNotesScreenState extends State<AddDishNotesScreen> {
  // final RestaurantDetailsViewModel model;
  final SearchViewModel searchViewModel;
  final CartBillDetailViewModel cartBillDetailViewModel;
  TextEditingController addNoteController;
  final int foodID;
  FocusNode addNoteTextFocus = new FocusNode();
  final int parentIndex;
  final int childIndex;
  String itemNotesData;
  bool textEdited = false;

  _AddDishNotesScreenState(
      { //this.model,
      this.searchViewModel,
      this.cartBillDetailViewModel,
      this.foodID,
      this.parentIndex,
      this.childIndex});

  @override
  void initState() {
    addNoteController = TextEditingController(text: widget.itemNotes);
    super.initState();
  }

  @override
  void dispose() {
    addNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    dragIcon(),
                    verticalSizedBox(),
                    Text(S.of(context).addNotesToYourDish,
                        style: Theme.of(context).textTheme.subhead),
                    verticalSizedBox(),
                    divider(),
                    verticalSizedBox(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        focusNode: addNoteTextFocus,
                        validator: (value) {
                          return nameValidation(value);
                        },
                        onChanged: (value) {
                          setState(() {
                            textEdited = true;
                          });
                        },
                        controller: addNoteController,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        maxLength: 200,
                        decoration: InputDecoration(
                          hintText: S.of(context).exampleMakeMyFoodSpicy,
                          hintStyle:
                              Theme.of(context).textTheme.display2.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        onSaved: (value) => {addNoteController.text = value},
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            //Navigator.of(context).pop();
                            if (textEdited) {
                              itemNotesData = addNoteController.text;
//                              if (widget.fromWhere == 1) {
//                                model.cartActionsRequest(
//                                  foodId: foodID,
//                                  action: itemNotes,
//                                  itemNotes: itemNotesData,
//                                );
//                                model.updateItemNotes(
//                                  parentIndex: parentIndex,
//                                  index: childIndex,
//                                  itemNotes: itemNotesData,
//                                );
//                              } else if (widget.fromWhere == 2) {
//                                searchViewModel.cartActionsRequest(
//                                  foodId: foodID,
//                                  action: itemNotes,
//                                  itemNotes: itemNotesData,
//                                );
//                                searchViewModel.updateItemNotes(
//                                  parentIndex: parentIndex,
//                                  index: childIndex,
//                                  itemNotes: itemNotesData,
//                                );
//                              } else if (widget.fromWhere == 3) {
//                                cartBillDetailViewModel.cartActionsRequest(
//                                  foodId: foodID,
//                                  action: itemNotes,
//                                  itemNotes: itemNotesData,
//                                );
//                                cartBillDetailViewModel.updateItemNotes(
//                                  parentIndex: parentIndex,
//                                  index: childIndex,
//                                  itemNotes: itemNotesData,
//                                );
//                              } else {}

//                              showSnackbar(
//                                  message: CommonStrings.notesSavedSuccessfully,
//                                  context: widget.mContext);

                              Navigator.of(context).pop(itemNotesData);
                            } else {}
                          },
                          child: Container(
                            height: 30,
                            width: 70,
                            decoration: BoxDecoration(
                              color: textEdited ? appColor : Colors.grey,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text(
                                S.of(context).done,
                                style: Theme.of(context)
                                    .textTheme
                                    .display3
                                    .copyWith(
                                      color: white,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
