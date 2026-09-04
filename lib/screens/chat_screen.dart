import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../models/chat_appointment_model.dart';
import '../models/chat_treatment_request_model.dart';
import '../services/media_service.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/enums.dart';
import '../view_models/chat_view_model.dart';
import '../widgets/chat/chat_message_bubble.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/dialogs/share_treatment_request_dialog.dart';
import '../widgets/grey_container.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const String routeName = '/chat-screen';

  final bool showBackButton;

  const ChatScreen({super.key, this.showBackButton = true});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _showClinicInfo = false;

  final List<String> _quickTemplates = [
    'Schedule Appointment',
    'Ask About Treatment',
    'Send Face Scan Photo',
    'Request Pricing',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).loadMessages();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage({
    String? customText,
    MessageType messageType = MessageType.text,
    String? mediaUrl,
    String? documentName,
    String? documentUrl,
    ChatTreatmentRequestModel? sharedRequestData,
    ChatAppointmentData? appointmentData,
  }) async {
    final text = customText ?? _messageController.text.trim();
    if (text.isEmpty &&
        messageType == MessageType.text &&
        documentName == null &&
        mediaUrl == null &&
        sharedRequestData == null &&
        appointmentData == null) {
      return;
    }

    if (messageType == MessageType.media && mediaUrl == null) {
      await _pickMediaAndSend();
      return;
    }

    if (messageType == MessageType.document && documentUrl == null) {
      await _pickDocumentAndSend();
      return;
    }

    await ref
        .read(chatProvider.notifier)
        .sendChatMessage(
          type: messageType,
          content: text,
          mediaUrl: mediaUrl,
          documentUrl: documentUrl,
        );

    _messageController.clear();
    _scrollToBottom();
  }

  Future<void> _pickMediaAndSend() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) {
      return;
    }

    final mediaUrl = await MediaService().uploadMedia(
      path: 'chat/media',
      file: picked,
    );
    if (mediaUrl == null) {
      return;
    }

    await _sendMessage(
      customText: 'Shared media.',
      messageType: MessageType.media,
      mediaUrl: mediaUrl,
    );
  }

  Future<void> _pickDocumentAndSend() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: false,
    );
    final file = result.singleOrNull;
    if (file == null || file.path == null) {
      return;
    }

    final documentUrl = await MediaService().uploadMedia(
      path: 'chat/documents',
      file: file,
    );
    if (documentUrl == null) {
      return;
    }

    await _sendMessage(
      customText: 'Shared document.',
      messageType: MessageType.document,
      documentName: file.name,
      documentUrl: documentUrl,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, _) {
        ref.read(chatProvider.notifier).clearSelectedChatAndMessages();
      },
      child: Scaffold(
        backgroundColor: CustomColors.whiteColor,
        appBar: CustomAppBar(
          showBackButton: widget.showBackButton,
          showTitle: false,
          actions: [
            Expanded(
              child: Row(
                mainAxisAlignment: .start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: context.w(40),
                        height: context.w(40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColors.purpleColor.withValues(
                            alpha: 0.1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'S',
                            style: TextStyle(
                              fontSize: context.sp(16),
                              fontWeight: FontWeight.bold,
                              color: CustomColors.purpleColor,
                              fontFamily: 'Degular',
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: context.w(12),
                          height: context.w(12),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'SkinSync Clinic',
                                style: CustomFonts.black16w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: context.w(6)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(6),
                                vertical: context.h(2),
                              ),
                              decoration: BoxDecoration(
                                color: CustomColors.purpleColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  context.r(8),
                                ),
                              ),
                              child: Text(
                                'Verified',
                                style: CustomFonts.black10w600.copyWith(
                                  color: CustomColors.purpleColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          'Aesthetics & Dermatology',
                          style: CustomFonts.grey12w400,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.w(8)),
                  GreyContainer(
                    icon: _showClinicInfo
                        ? Icons.info_rounded
                        : Icons.info_outline_rounded,
                    onTap: () {
                      setState(() {
                        _showClinicInfo = !_showClinicInfo;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (_showClinicInfo) _buildClinicInfoBanner(context),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(context.w(16)),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(context.r(24)),
                    border: Border.all(color: Colors.grey.shade200, width: 1.5),
                    boxShadow: CustomColors.cardShadow,
                  ),
                  child: Column(
                    children: [
                      _buildDateDivider(context),
                      Expanded(
                        child: Consumer(
                          builder: (_, ref, _) {
                            final messages = ref.watch(
                              chatProvider.select(
                                (s) => s.messagesData?.messages,
                              ),
                            );
                            return ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(16),
                                vertical: context.h(12),
                              ),
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: messages?.length ?? 0,
                              itemBuilder: (context, index) {
                                final message = messages![index];
                                return ChatMessageBubble(message: message);
                              },
                            );
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

  Widget _buildClinicInfoBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(4),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(12),
      ),
      decoration: BoxDecoration(
        color: CustomColors.whiteColor,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: CustomColors.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(context, 'Email', 'info@skinsync.com'),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.r(16)),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text('Today, Aug 28, 2026', style: CustomFonts.grey12w400),
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
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            Icon(
              Icons.flash_on_rounded,
              size: context.sp(16),
              color: CustomColors.purpleColor,
            ),
            SizedBox(width: context.w(6)),
            Text('Quick:', style: CustomFonts.grey12w400),
            SizedBox(width: context.w(8)),
            ..._quickTemplates.map(
              (template) => Padding(
                padding: EdgeInsets.only(right: context.w(8)),
                child: ActionChip(
                  label: Text(template),
                  labelStyle: TextStyle(
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: CustomColors.purpleColor,
                    fontFamily: 'Degular',
                  ),
                  backgroundColor: CustomColors.purpleColor.withValues(
                    alpha: 0.1,
                  ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(context.r(22)),
        ),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.attach_file_rounded,
              color: CustomColors.blackColor,
              size: context.sp(22),
            ),
            tooltip: 'Attach Media, Document, Request or Appointment',
            onSelected: (value) {
              if (value == 'photo') {
                _pickMediaAndSend();
              } else if (value == 'document') {
                _pickDocumentAndSend();
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
                      messageType: MessageType.sharedRequest,
                      sharedRequestData: selectedReq,
                    );
                  }
                });
              } else if (value == 'appointment') {
                _sendMessage(
                  customText: 'Attached appointment confirmation details.',
                  messageType: MessageType.appointment,
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
                    Icon(
                      Icons.image_outlined,
                      size: context.sp(18),
                      color: CustomColors.purpleColor,
                    ),
                    SizedBox(width: context.w(12)),
                    Text('Send Photo / Media', style: CustomFonts.black14w400),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'document',
                child: Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf_outlined,
                      size: context.sp(18),
                      color: CustomColors.purpleColor,
                    ),
                    SizedBox(width: context.w(12)),
                    Text('Send Document (PDF)', style: CustomFonts.black14w400),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'shared_request',
                child: Row(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: context.sp(18),
                      color: CustomColors.purpleColor,
                    ),
                    SizedBox(width: context.w(12)),
                    Text(
                      'Share Treatment Request',
                      style: CustomFonts.black14w400,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'appointment',
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: context.sp(18),
                      color: CustomColors.purpleColor,
                    ),
                    SizedBox(width: context.w(12)),
                    Text(
                      'Share Appointment Card',
                      style: CustomFonts.black14w400,
                    ),
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
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(24)),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(24)),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(24)),
                  borderSide: const BorderSide(color: CustomColors.purpleColor),
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
              decoration: BoxDecoration(
                gradient: CustomColors.purpleBlueGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.purpleColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.send_rounded,
                color: CustomColors.blackColor,
                size: context.sp(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
