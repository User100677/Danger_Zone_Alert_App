import 'package:danger_zone_alert/comment/model/post.dart';
import 'package:danger_zone_alert/comment/widgets/post_list.dart';
import 'package:danger_zone_alert/comment/widgets/text_input.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:danger_zone_alert/shared/constants/app_constants.dart';
import 'package:danger_zone_alert/shared/widgets/alert_dialog_box.dart';
import 'package:danger_zone_alert/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CommentScreen extends StatefulWidget {
  final bool permission;
  final UserModel user;
  final Area area;

  const CommentScreen({
    Key? key,
    required this.permission,
    required this.user,
    required this.area,
  }) : super(key: key);

  @override
  _CommentScreenController createState() => _CommentScreenController();
}

class _CommentScreenController extends State<CommentScreen> {
  bool isAscending = false;
  String selected = 'Time';
  List<String> selection = ['Time', 'Like'];

  handleSortButtonPressed() => setState(() {
        isAscending = !isAscending;
      });

  handlePostPressed(String text) async {
    if (widget.permission == false) {
      showAlertDialogBox(
          AlertType.warning,
          kLocationOutOfBoundTitleText,
          kLocationOutOfBoundDescriptionText,
          kLocationOutOfBoundHintText,
          context);

      return;
    }

    if (text.isEmpty) return;

    await DatabaseService(uid: widget.user.uid)
        .postAreaCommentData(widget.area.latLng, text, widget.user.email);
  }

  List<Post> sortView(List<Post> posts) {
    if (isAscending) {
      return posts..sort((post1, post2) => post2.likes.compareTo(post1.likes));
    }
    return posts
      ..sort((post1, post2) => post2.dateTime.compareTo(post1.dateTime));
  }

  handleDropDownSelected(value) {
    setState(() {
      selected = value;
      if (value == selection[1]) {
        isAscending = true;
      } else {
        isAscending = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _CommentScreenView(this);
}

class _CommentScreenView
    extends WidgetView<CommentScreen, _CommentScreenController> {
  const _CommentScreenView(_CommentScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text('Area Comments',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w800)),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  size: 20,
                  color: Colors.white,
                ))),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const SizedBox(width: 12.0),
                  Text('Sort By: ',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500)),
                  Container(
                    margin: const EdgeInsets.only(left: 6.0),
                    width: 60.0,
                    color: Colors.white,
                    child: DropdownButtonFormField<String>(
                      value: state.selected,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      items: state.selection.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        state.handleDropDownSelected(value);
                      },
                    ),
                  ),
                ],
              ),
              Container(height: 6.0, color: const Color(0xffDAE0E6)),
              Expanded(
                  child: Container(
                color: const Color(0xffDAE0E6),
                child: PostList(
                    user: widget.user,
                    area: widget.area,
                    permission: widget.permission,
                    sortView: state.sortView),
              )),
              TextInputWidget(state.handlePostPressed),
            ]));
  }
}
