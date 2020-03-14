import '../../apis/app.dart';
import '../../common/Ycn.dart';
import 'package:flutter/material.dart';
import 'package:dwbs_app_flutter/common/components.dart';

class PageProblemFeedback extends StatefulWidget {
  PageProblemFeedback({Key key}) : super(key: key);

  @override
  _PageProblemFeedbackState createState() => _PageProblemFeedbackState();
}

class _PageProblemFeedbackState extends State<PageProblemFeedback> {
  bool _loading = false;
  bool _requesting = false;
  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();

  void _submit() {
    if (this._textEditingController.text.isEmpty) {
      Ycn.toast('请输入反馈内容');
    } else {
      this._focusNode.unfocus();
      if (!this._requesting) {
        setState(() {
          this._loading = true;
          this._requesting = true;
        });
        apiFeedback({'feedback': this._textEditingController.text}).then((status) {
          Ycn.toast('反馈成功，非常感谢您的建议');
          this._textEditingController.text = '';
        }).whenComplete(() {
          setState(() {
            this._loading = false;
            this._requesting = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: this._loading,
      child: Scaffold(
        appBar: Ycn.appBar(context, title: '问题反馈'),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: Ycn.px(20)),
            Container(
              width: Ycn.px(690),
              height: Ycn.px(382),
              padding: EdgeInsets.symmetric(vertical: Ycn.px(8), horizontal: Ycn.px(30)),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Ycn.px(10))),
              child: TextField(
                maxLines: 7,
                maxLength: 200,
                autofocus: true,
                focusNode: this._focusNode,
                controller: this._textEditingController,
                style: TextStyle(fontSize: Ycn.px(26), height: 1.25),
                decoration: InputDecoration(
                  hintText: '请输入反馈内容，我们会为您更好的服务',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: Ycn.px(26), color: Theme.of(context).textTheme.display1.color),
                ),
              ),
            ),
            SizedBox(height: Ycn.px(52)),
            Container(
              height: Ycn.px(80),
              width: Ycn.px(630),
              child: FlatButton(
                onPressed: this._submit,
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Ycn.px(80))),
                child: Text('提交反馈', style: TextStyle(color: Colors.white, fontSize: Ycn.px(34))),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
