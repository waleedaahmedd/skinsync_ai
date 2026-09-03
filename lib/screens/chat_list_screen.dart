import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  static const String routeName = '/chat-list-screen';

  final bool showBackButton;

  const ChatListScreen({
    super.key,
    this.showBackButton = true,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<ChatListItem> _allChats = [
    ChatListItem(
      id: '1',
      clinicName: 'SkinSync Clinic',
      lastMessage: 'Hello! Thank you for reaching out to SkinSync Clinic.',
      time: '10:22 AM',
      unreadCount: 2,
      isOnline: true,
    ),
    ChatListItem(
      id: '2',
      clinicName: 'Aesthetic Dermatology Center',
      lastMessage: 'Your appointment for Sep 05 has been confirmed.',
      time: 'Yesterday',
      unreadCount: 0,
      isOnline: false,
    ),
    ChatListItem(
      id: '3',
      clinicName: 'Radiant Glow Skin Clinic',
      lastMessage: 'Please review pre-treatment care guidelines before your visit.',
      time: '24 Aug',
      unreadCount: 1,
      isOnline: true,
    ),
    ChatListItem(
      id: '4',
      clinicName: 'Elite Medical Aesthetics',
      lastMessage: 'Your treatment simulation request is ready for review.',
      time: '21 Aug',
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  List<ChatListItem> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _filteredChats = List.from(_allChats);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterChats(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChats = List.from(_allChats);
      } else {
        _filteredChats = _allChats
            .where((chat) =>
                chat.clinicName.toLowerCase().contains(query.toLowerCase()) ||
                chat.lastMessage.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: CustomColors.blueWhitePurpleGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(20),
                    vertical: context.h(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(context),
                      SizedBox(height: context.h(20)),
                      _buildChatListSection(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.showBackButton) ...[
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: CustomColors.blackColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            SizedBox(width: context.w(8)),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages',
                  style: CustomFonts.black22w600,
                ),
                SizedBox(height: context.h(2)),
                Text(
                  'Direct messaging with clinics and specialists.',
                  style: CustomFonts.grey13w400,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.whiteColor,
        borderRadius: BorderRadius.circular(context.r(14)),
        border: Border.all(color: CustomColors.greyColor),
      ),
      child: TextField(
        controller: _searchController,
        style: CustomFonts.black14w400,
        decoration: InputDecoration(
          hintText: 'Search clinics or messages...',
          hintStyle: CustomFonts.grey14w400,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: CustomColors.silverColor,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: CustomColors.silverColor),
                  onPressed: () {
                    _searchController.clear();
                    _filterChats('');
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.w(16),
            vertical: context.h(14),
          ),
        ),
        onChanged: _filterChats,
      ),
    );
  }

  Widget _buildChatListSection(BuildContext context) {
    if (_filteredChats.isEmpty) {
      return Container(
        padding: EdgeInsets.all(context.r(32)),
        decoration: BoxDecoration(
          color: CustomColors.whiteColor,
          borderRadius: BorderRadius.circular(context.r(16)),
          border: Border.all(color: CustomColors.greyColor),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(context.r(16)),
                decoration: const BoxDecoration(
                  color: CustomColors.greyColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 40,
                  color: CustomColors.silverColor,
                ),
              ),
              SizedBox(height: context.h(16)),
              Text('No conversations found', style: CustomFonts.black18w600),
              SizedBox(height: context.h(8)),
              Text(
                'Try clearing your search keyword.',
                style: CustomFonts.grey14w400,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredChats.length,
      itemBuilder: (context, index) {
        final item = _filteredChats[index];
        return _buildChatCard(context, item);
      },
    );
  }

  Widget _buildChatCard(BuildContext context, ChatListItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(12)),
      decoration: BoxDecoration(
        color: CustomColors.whiteColor,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: CustomColors.greyColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(context.r(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(context.r(16)),
          onTap: () {
            Navigator.of(context).pushNamed(
              ChatScreen.routeName,
              arguments: true,
            );
          },
          child: Padding(
            padding: EdgeInsets.all(context.r(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: context.r(24),
                      backgroundColor: CustomColors.lightPurpleColor,
                      child: Text(
                        item.clinicName.isNotEmpty
                            ? item.clinicName[0]
                            : 'C',
                        style: TextStyle(
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.bold,
                          color: CustomColors.darkPurple,
                          fontFamily: 'Degular',
                        ),
                      ),
                    ),
                    if (item.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: context.r(12),
                          height: context.r(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: CustomColors.whiteColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: context.w(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.clinicName,
                              style: CustomFonts.black16w600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            item.time,
                            style: item.unreadCount > 0
                                ? CustomFonts.darkPurple12w600
                                : CustomFonts.grey12w400,
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(4)),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.lastMessage,
                              style: item.unreadCount > 0
                                  ? CustomFonts.black14w600
                                  : CustomFonts.grey14w400,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (item.unreadCount > 0) ...[
                            SizedBox(width: context.w(8)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(8),
                                vertical: context.h(2),
                              ),
                              decoration: const BoxDecoration(
                                color: CustomColors.darkPurple,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${item.unreadCount}',
                                style: CustomFonts.white10w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatListItem {
  final String id;
  final String clinicName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  ChatListItem({
    required this.id,
    required this.clinicName,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}
