// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:cookies_shop/models/user-model.dart';
import 'package:cookies_shop/utils/app-constant.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  UserModel userModel;
  ProfileScreen({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor),
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.appScendoryColor,
              fontSize: 20),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: AppConstant.appMainColor,
                      backgroundImage: userModel.userImg.isNotEmpty 
                          ? NetworkImage(userModel.userImg)
                          : null,
                    ),
                    if (userModel.userImg.isEmpty)
                      Text(
                        userModel.username[0], 
                        style: TextStyle(
                          color: AppConstant.appTextColor,
                          fontSize: 24,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            _buildUserInfoBox(context, userModel),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoBox(BuildContext context, UserModel userModel) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppConstant.appCardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.person, 'Username', userModel.username),
          _buildInfoRow(Icons.email, 'Email', userModel.email),
          _buildInfoRow(Icons.phone, 'Phone', userModel.phone),
          _buildInfoRow(Icons.location_city, 'City', userModel.city),
          _buildInfoRow(Icons.home, 'Address', userModel.userAddress),
          _buildInfoRow(Icons.location_on, 'Country', userModel.country),
          _buildInfoRow(Icons.streetview, 'Street', userModel.street),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppConstant.appScendoryColor),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
