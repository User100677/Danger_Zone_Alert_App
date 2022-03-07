import 'package:danger_zone_alert/blocs/application_bloc.dart';
import 'package:danger_zone_alert/models/place_search.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

import 'area_marker.dart';

Widget buildFloatingSearchBar(context,
    FloatingSearchBarController searchBarController, AreaMarker areaMarker) {
  final applicationBloc = Provider.of<ApplicationBloc>(context);
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

  final actions = [
    FloatingSearchBarAction(
      showIfOpened: false,
      child: CircularButton(
        icon: const Icon(Icons.search),
        onPressed: () {},
      ),
    ),
    FloatingSearchBarAction.searchToClear(
      showIfClosed: false,
    ),
  ];

  return Consumer<SearchModel>(
    builder: (context, model, _) => FloatingSearchBar(
      automaticallyImplyBackButton: false,
      controller: searchBarController,
      clearQueryOnClose: false,
      hint: 'Search...',
      iconColor: const Color(0xff818181),
      margins: const EdgeInsets.only(top: 12.0, left: 10.0, right: 10.0),
      scrollPadding: EdgeInsets.zero,
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      actions: actions,
      progress: model.isLoading,
      onQueryChanged: (query) => model.onQueryChanged(query, applicationBloc),
      transition: CircularFloatingSearchBarTransition(spacing: 16.0),
      builder: (context, _) =>
          buildExpandableBody(model, applicationBloc, areaMarker),
    ),
  );
}

Widget buildExpandableBody(
    SearchModel model, ApplicationBloc applicationBloc, AreaMarker areaMarker) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: ImplicitlyAnimatedList<PlaceSearch>(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // items: model.suggestions,
        items: applicationBloc.searchResults,
        insertDuration: const Duration(milliseconds: 700),
        itemBuilder: (context, animation, item, i) {
          return SizeFadeTransition(
            animation: animation,
            child: SearchItem(
              place: item,
              areaMarker: areaMarker,
            ),
          );
        },
        updateItemBuilder: (context, animation, item) {
          return FadeTransition(
            opacity: animation,
            child: SearchItem(place: item, areaMarker: areaMarker),
          );
        },
        areItemsTheSame: (a, b) => a == b,
      ),
    ),
  );
}

class SearchItem extends StatefulWidget {
  PlaceSearch place;
  AreaMarker areaMarker;

  SearchItem({Key? key, required this.place, required this.areaMarker})
      : super(key: key);

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final model = Provider.of<SearchModel>(context, listen: false);
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () async {
            FloatingSearchBar.of(context)?.close();
            Future.delayed(
              const Duration(milliseconds: 500),
              () => model.clear(),
            );
            await applicationBloc.setSelectedLocation(widget.place.placeId);
            setState(() {
              widget.areaMarker.addMarker(applicationBloc
                  .selectedLocationStatic!.geometry.location.latLng);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(
                  width: 36,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: Icon(Icons.place, key: Key('place')),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.place.description,
                        style: textTheme.subtitle1,
                      ),
                      // const SizedBox(height: 2),
                      // Text(
                      //   widget.place.description,
                      //   style: textTheme.bodyText2
                      //       ?.copyWith(color: Colors.grey.shade600),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (applicationBloc.searchResults.isNotEmpty) const Divider(height: 0),
      ],
    );
  }
}

// for loading animation purposes
class SearchModel extends ChangeNotifier {
  bool _isLoading = false;
  String _query = '';

  void onQueryChanged(String query, ApplicationBloc applicationBloc) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isNotEmpty) {
      await applicationBloc.searchPlaces(query);
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    notifyListeners();
  }

  bool get isLoading => _isLoading;
}
