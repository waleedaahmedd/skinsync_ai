import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_search_field.dart';
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
      if (query.trim().isEmpty) {
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
      backgroundColor: CustomColors.whiteColor,
      appBar: CustomAppBar(
        showBackButton: widget.showBackButton,
        showTitle: true,
        title: "Messages",
      ),
      body: Column(
        children: [
          SizedBox(height: context.h(10)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(24)),
            child: CustomSearchField(
              controller: _searchController,
              hintText: "Search clinics or messages...",
              onChanged: _filterChats,
            ),
          ),
          SizedBox(height: context.h(16)),
          Expanded(
            child: _filteredChats.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(24),
                      vertical: context.h(8),
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredChats.length,
                    itemBuilder: (context, index) {
                      final item = _filteredChats[index];
                      return _buildChatCard(context, item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mark_chat_read_outlined,
              size: context.sp(64),
              color: Colors.grey.shade300,
            ),
            SizedBox(height: context.h(16)),
            Text("No Conversations Found", style: CustomFonts.grey800_20w600),
            SizedBox(height: context.h(6)),
            Text(
              "Try searching for a different keyword or check back later.",
              textAlign: TextAlign.center,
              style: CustomFonts.textGrey14w400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatCard(BuildContext context, ChatListItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(12)),
      decoration: BoxDecoration(
        color: CustomColors.whiteColor,
        borderRadius: BorderRadius.circular(context.r(20)),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: CustomColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(20)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                ChatScreen.routeName,
                arguments: true,
              );
            },
            child: Padding(
              padding: EdgeInsets.all(context.w(16)),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: context.w(48),
                        height: context.w(48),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColors.purpleColor.withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Text(
                            item.clinicName.isNotEmpty ? item.clinicName[0] : 'C',
                            style: TextStyle(
                              fontSize: context.sp(18),
                              fontWeight: FontWeight.bold,
                              color: CustomColors.purpleColor,
                              fontFamily: 'Degular',
                            ),
                          ),
                        ),
                      ),
                      if (item.isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: context.w(14),
                            height: context.w(14),
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
                  SizedBox(width: context.w(14)),
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
                            SizedBox(width: context.w(8)),
                            Text(
                              item.time,
                              style: item.unreadCount > 0
                                  ? CustomFonts.black12w600.copyWith(
                                      color: CustomColors.purpleColor,
                                    )
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
                                decoration: BoxDecoration(
                                  color: CustomColors.purpleColor,
                                  borderRadius: BorderRadius.circular(context.r(10)),
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
                  SizedBox(width: context.w(6)),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade400,
                    size: context.sp(22),
                  ),
                ],
              ),
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
