import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../models/chat_appointment_model.dart';
import '../models/chat_message_model.dart';
import '../models/chat_treatment_request_model.dart';
import '../utils/ai_dummy_data.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/enums.dart';
import '../widgets/chat/chat_message_bubble.dart';
import '../widgets/dialogs/share_treatment_request_dialog.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';

  final bool showBackButton;

  const ChatScreen({
    super.key,
    this.showBackButton = true,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _showClinicInfo = false;

  final List<String> _quickTemplates = [
    'Schedule Appointment',
    'Ask About Treatment',
    'Send Face Scan Photo',
    'Request Pricing',
  ];

  late final List<ChatMessageModel> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(AiDummyData.chatDummyMessages);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage({
    String? customText,
    ChatMessageType messageType = ChatMessageType.normal,
    String? mediaUrl,
    String? mediaCaption,
    String? documentName,
    String? documentSize,
    ChatTreatmentRequestModel? sharedRequestData,
    ChatAppointmentData? appointmentData,
  }) {
    final text = customText ?? _messageController.text.trim();
    if (text.isEmpty &&
        messageType == ChatMessageType.normal &&
        documentName == null &&
        mediaUrl == null &&
        sharedRequestData == null &&
        appointmentData == null) {
      return;
    }

    final now = DateTime.now();
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    setState(() {
      _messages.add(
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderName: 'You',
          time: timeStr,
          isMe: true,
          isRead: false,
          messageType: messageType,
          text: text,
          mediaUrl: mediaUrl,
          mediaCaption: mediaCaption,
          documentName: documentName,
          documentSize: documentSize,
          sharedRequestData: sharedRequestData,
          appointmentData: appointmentData,
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
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
              if (_showClinicInfo) ...[
                _buildClinicInfoBanner(context),
              ],
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(context.r(16)),
                  decoration: BoxDecoration(
                    color: CustomColors.whiteColor,
                    borderRadius: BorderRadius.circular(context.r(16)),
                    border: Border.all(color: CustomColors.greyColor),
                  ),
                  child: Column(
                    children: [
                      _buildDateDivider(context),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(16),
                            vertical: context.h(12),
                          ),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            return ChatMessageBubble(message: message);
                          },
                        ),
                      ),
                      const Divider(color: CustomColors.greyColor, height: 1),
                      _buildQuickPresetsRow(context),
                      const Divider(color: CustomColors.greyColor, height: 1),
                      _buildInputArea(context),
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
            SizedBox(width: context.w(6)),
          ],
          Stack(
            children: [
              CircleAvatar(
                radius: context.r(22),
                backgroundColor: CustomColors.lightPurpleColor,
                child: Text(
                  'S',
                  style: TextStyle(
                    fontSize: context.sp(16),
                    fontWeight: FontWeight.bold,
                    color: CustomColors.darkPurple,
                    fontFamily: 'Degular',
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: context.r(10),
                  height: context.r(10),
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
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'SkinSync Clinic',
                      style: CustomFonts.black16w600,
                    ),
                    SizedBox(width: context.w(8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(6),
                        vertical: context.h(2),
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.greyColor,
                        borderRadius: BorderRadius.circular(context.r(10)),
                      ),
                      child: Text(
                        'Verified',
                        style: CustomFonts.grey12w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(2)),
                Text(
                  'Aesthetics & Dermatology Center',
                  style: CustomFonts.grey12w400,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _showClinicInfo = !_showClinicInfo;
              });
            },
            tooltip: 'Toggle Clinic Details',
            icon: Icon(
              _showClinicInfo
                  ? Icons.info_rounded
                  : Icons.info_outline_rounded,
              color: CustomColors.darkPurple,
              size: context.sp(22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicInfoBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.w(16)),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(12),
      ),
      decoration: BoxDecoration(
        color: CustomColors.lightPurpleColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(context.r(12)),
        border: Border.all(color: CustomColors.lightPurpleColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(context, 'Email', 'info@skinsyncclinic.com'),
          _buildInfoItem(context, 'Phone', '+1 (800) 555-0199'),
          _buildInfoItem(context, 'Location', 'Beverly Hills, CA'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.grey12w400),
        SizedBox(height: context.h(2)),
        Text(value, style: CustomFonts.black12w600),
      ],
    );
  }

  Widget _buildDateDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.h(12)),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(14),
            vertical: context.h(4),
          ),
          decoration: BoxDecoration(
            color: CustomColors.greyColor,
            borderRadius: BorderRadius.circular(context.r(16)),
          ),
          child: Text(
            'Today, Aug 28, 2026',
            style: CustomFonts.grey12w400,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickPresetsRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(8),
      ),
      color: CustomColors.greyColor.withValues(alpha: 0.3),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Icon(
              Icons.flash_on_rounded,
              size: context.sp(16),
              color: CustomColors.darkPurple,
            ),
            SizedBox(width: context.w(6)),
            Text(
              'Quick:',
              style: CustomFonts.grey12w400,
            ),
            SizedBox(width: context.w(8)),
            ..._quickTemplates.map(
              (template) => Padding(
                padding: EdgeInsets.only(right: context.w(8)),
                child: ActionChip(
                  label: Text(template),
                  labelStyle: TextStyle(
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: CustomColors.darkPurple,
                    fontFamily: 'Degular',
                  ),
                  backgroundColor: CustomColors.lightPurpleColor,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.r(16)),
                  ),
                  onPressed: () {
                    _messageController.text = template;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(10),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.attach_file_rounded,
              color: CustomColors.silverColor,
              size: context.sp(22),
            ),
            tooltip: 'Attach Media, Document, Request or Appointment',
            onSelected: (value) {
              if (value == 'photo') {
                _sendMessage(
                  customText: 'Shared pre-treatment face scan.',
                  messageType: ChatMessageType.media,
                  mediaUrl:
                      'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800&q=80',
                  mediaCaption: 'Pre-treatment Skin Assessment Photo',
                );
              } else if (value == 'document') {
                _sendMessage(
                  customText: 'Shared medical history details.',
                  messageType: ChatMessageType.document,
                  documentName: 'Patient_Medical_History.pdf',
                  documentSize: '1.2 MB',
                );
              } else if (value == 'shared_request') {
                showDialog<ChatTreatmentRequestModel>(
                  context: context,
                  builder: (context) => const ShareTreatmentRequestDialog(
                    patientName: 'Jane Cooper',
                  ),
                ).then((selectedReq) {
                  if (selectedReq != null) {
                    _sendMessage(
                      customText: 'Attached shared treatment request details.',
                      messageType: ChatMessageType.sharedRequest,
                      sharedRequestData: selectedReq,
                    );
                  }
                });
              } else if (value == 'appointment') {
                _sendMessage(
                  customText: 'Attached appointment confirmation details.',
                  messageType: ChatMessageType.appointment,
                  appointmentData: ChatAppointmentData(
                    appointmentId: 408,
                    patientName: 'Jane Cooper',
                    serviceName: 'Dermal Fillers Follow-up',
                    date: 'Sep 12, 2026',
                    time: '11:30 AM',
                    practitionerName: 'Dr. Sarah Johnson',
                    status: 'Confirmed',
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'photo',
                child: Row(
                  children: [
                    Icon(Icons.image_outlined,
                        size: context.sp(18), color: CustomColors.darkPurple),
                    SizedBox(width: context.w(12)),
                    Text('Send Photo / Media', style: CustomFonts.black14w400),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'document',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_outlined,
                        size: context.sp(18), color: CustomColors.darkPurple),
                    SizedBox(width: context.w(12)),
                    Text('Send Document (PDF)', style: CustomFonts.black14w400),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'shared_request',
                child: Row(
                  children: [
                    Icon(Icons.assignment_outlined,
                        size: context.sp(18), color: CustomColors.darkPurple),
                    SizedBox(width: context.w(12)),
                    Text('Share Treatment Request', style: CustomFonts.black14w400),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'appointment',
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_outlined,
                        size: context.sp(18), color: CustomColors.darkPurple),
                    SizedBox(width: context.w(12)),
                    Text('Share Appointment Card', style: CustomFonts.black14w400),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: context.w(8)),
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              style: CustomFonts.black14w400,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: CustomFonts.grey14w400,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(24)),
                  borderSide: const BorderSide(color: CustomColors.greyColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(24)),
                  borderSide: const BorderSide(color: CustomColors.greyColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(24)),
                  borderSide: const BorderSide(color: CustomColors.darkPurple),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(10),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: context.w(8)),
          InkWell(
            onTap: () => _sendMessage(),
            borderRadius: BorderRadius.circular(context.r(24)),
            child: Container(
              padding: EdgeInsets.all(context.r(12)),
              decoration: const BoxDecoration(
                color: CustomColors.darkPurple,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send_rounded,
                color: CustomColors.whiteColor,
                size: context.sp(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
