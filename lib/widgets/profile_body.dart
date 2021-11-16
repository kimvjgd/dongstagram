import 'package:cached_network_image/cached_network_image.dart';
import 'package:dongstagram/constant/common_size.dart';
import 'package:dongstagram/constant/screen_size.dart';
import 'package:dongstagram/models/user_model_state.dart';
import 'package:dongstagram/screens/profile_screen.dart';
import 'package:dongstagram/widgets/rounded_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatefulWidget {
  final Function() onMenuChanged;

  const ProfileBody({Key? key, required this.onMenuChanged}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftImagesPageMargin = 0;
  double _rightImagesPageMargin = size!.width;
  late AnimationController _iconAnimationController;

  @override
  void initState() {
    _iconAnimationController =
        AnimationController(vsync: this, duration: duration);
    super.initState();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _appbar(),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(common_gap),
                          child: RoundedAvatar(
                            size: 80,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: common_gap),
                            child: Table(
                              children: [
                                TableRow(children: [
                                  _valueText('123'),
                                  _valueText('3'),
                                  _valueText('731841'),
                                ]),
                                TableRow(children: [
                                  _labelText('Post'),
                                  _labelText('Followers'),
                                  _labelText('Followings'),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    _username(context),
                    _userBio(),
                    _editProfileBtn(),
                    _tabButtons(),
                    _selectedIndicator(),
                  ]),
                ),
                SliverToBoxAdapter(                     // sliver에 일반적인 widget을 넣고 싶을때 slivertoboxadapter을 사용한다.
                    child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: duration,
                      transform: Matrix4.translationValues(
                          _leftImagesPageMargin, 0, 0),
                      curve: Curves.fastOutSlowIn,
                      child: _images(),
                    ),
                    AnimatedContainer(
                      duration: duration,
                      transform: Matrix4.translationValues(
                          _rightImagesPageMargin, 0, 0),
                      curve: Curves.fastOutSlowIn,
                      child: _images(),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _appbar() {
    return Row(
      children: [
        SizedBox(width: 44),
        Expanded(
            child: Text(
          'Dongstagram',
          textAlign: TextAlign.center,
        )),
        IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _iconAnimationController,
          ),
          onPressed: () {
            widget.onMenuChanged();
            _iconAnimationController.status == AnimationStatus.completed
                ? _iconAnimationController.reverse()
                : _iconAnimationController.forward();
          },
        )
      ],
    );
  }

  Text _valueText(String value) => Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      );

  Text _labelText(String label) => Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
      );

  GridView _images() {
    return GridView.count(
      shrinkWrap: true,                                       // true로 안해놓으면 필요하지 않은 부분까지 공간을 차지해서 true 로 바꿔
      crossAxisCount: 3,
      childAspectRatio: 1,
      physics: NeverScrollableScrollPhysics(),            // gridview에서는 scroll을 무시하고 위의 customscrollview에서만 scroll이 된다.
      children: List.generate(
          30,
          (index) => CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: 'https://picsum.photos/id/$index/100/100')),
    );
  }

  Row _tabButtons() {
    return Row(
      children: [
        Expanded(
            child: IconButton(
                onPressed: () {
                  _tabSelected(SelectedTab.left);
                },
                icon: ImageIcon(
                  AssetImage('assets/images/grid.png'),
                  color: _selectedTab == SelectedTab.left
                      ? Colors.black
                      : Colors.black26,
                ))),
        Expanded(
            child: IconButton(
                onPressed: () {
                  _tabSelected(SelectedTab.right);
                },
                icon: ImageIcon(
                  AssetImage('assets/images/saved.png'),
                  color: _selectedTab == SelectedTab.right
                      ? Colors.black
                      : Colors.black26,
                ))),
      ],
    );
  }

  _tabSelected(SelectedTab selectedTab) {
    setState(() {
      switch (selectedTab) {
        case SelectedTab.left:
          _selectedTab = SelectedTab.left;
          _leftImagesPageMargin = 0;
          _rightImagesPageMargin = size!.width;
          break;
        case SelectedTab.right:
          _selectedTab = SelectedTab.right;
          _leftImagesPageMargin = -size!.width;
          _rightImagesPageMargin = 0;
          break;
      }
    });
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
      duration: duration,
      alignment: _selectedTab == SelectedTab.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      curve: Curves.easeInOut,
      child: Container(
        height: 3,
        width: size!.width / 2,
        color: Colors.black87,
      ),
    );
  }
}

Padding _editProfileBtn() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: common_gap),
    child: SizedBox(
      height: 24,
      child: OutlineButton(
        onPressed: () {},
        borderSide: BorderSide(color: Colors.black45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

Widget _username(BuildContext context) {
  UserModelState userModelState = Provider.of<UserModelState>(context);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: common_gap),
    child: Text(
      userModelState == null || userModelState.userModel == null
          ? ""
          : userModelState.userModel.username,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

Widget _userBio() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: common_gap),
    child: Text(
      'This is what I believe!!',
      style: TextStyle(fontWeight: FontWeight.w400),
    ),
  );
}

enum SelectedTab { left, right }
