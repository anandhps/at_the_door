import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/data/model/response/search_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/response/prediction_model.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData suffixIcon;
  final Function iconPressed;
  final Color filledColor;
  final Function onSubmit;
  final Function onChanged;
  SearchField(
      {@required this.controller,
      @required this.hint,
      @required this.suffixIcon,
      @required this.iconPressed,
      this.filledColor,
      this.onSubmit,
      this.onChanged});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).disabledColor),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: widget.filledColor ?? Theme.of(context).cardColor,
          isDense: true,
          suffixIcon: IconButton(
            onPressed: widget.iconPressed,
            icon: Icon(widget.suffixIcon,
                color: Theme.of(context).textTheme.bodyText1.color),
          ),
        ),
        onSubmitted: widget.onSubmit,
      ),
      suggestionsCallback: (pattern) async {
        return await Get.find<LocationController>()
            .searchProducts(context, pattern);
      },
      itemBuilder: (context, SearchModel suggestion) {
        return Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Row(children: [
            Icon(Icons.search_rounded),
            Expanded(
              child: Text(suggestion.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontSize: Dimensions.fontSizeLarge,
                      )),
            ),
          ]),
        );
      },
      onSuggestionSelected: (SearchModel suggestion) {
        widget.controller.text = suggestion.name;
        widget.onSubmit(widget.controller.text);
      },
    );
  }
}
