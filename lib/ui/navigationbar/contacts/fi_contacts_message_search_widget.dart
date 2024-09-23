import 'package:FocusInbox/models/main/fi_main_model.dart';
import 'package:FocusInbox/utils/fi_display.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';
import '../../../backend/models/fi_backend_response.dart';
import '../../../backend/url_config.dart';
import '../../../utils/fi_log.dart';
import '../../base/fi_base_state.dart';
import 'fi_contact.dart';
import '../../base/fi_base_widget.dart';
import '../../utils/fi_ui_elements.dart';
import 'fi_contacts_message_search_model.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class FiContactsMessageSearchWidget extends FiBaseWidget {
  final FiContact? contact;

  const FiContactsMessageSearchWidget({super.key, this.contact});

  @override
  State<StatefulWidget> createState() => _FiContactsMessageSearchState();
}

class _FiContactsMessageSearchState extends FiBaseState<FiContactsMessageSearchWidget> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<DefaultInteraction> interactions = [];
  String _currentTooltipText = "Now";
  final ScrollController _scrollController = ScrollController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = "";


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _speech = stt.SpeechToText();
    _requestMicrophonePermission();  // Request microphone permission
  }

  void _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      // If permission is not granted, request it
      if (await Permission.microphone.request().isGranted) {
        print("Microphone permission granted");
      } else {
        print("Microphone permission denied");
      }
    } else {
      print("Microphone permission already granted");
    }
  }


  void _scrollListener() {
    setState(() {
      _currentTooltipText = "Some Date"; // Customize this logic as needed
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _speech.stop();  // Stop any ongoing speech recognition
    super.dispose();
  }


  @override
  Widget get content {
    return Scaffold(
      backgroundColor: const Color(0xFF131621),
      body: Stack(
        children: [
          Positioned(
            top: toY(50),
            left: toX(20),
            child: uiElements.backButton(() {
              Navigator.pop(context);
            }),
          ),
          Positioned(
            top: toY(100),
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                widget.contact?.name ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: toY(160),
            left: toX(0),
            right: toX(0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: toY(15)),
              color: Color(0xFF292C35),
              height: toY(60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: toX(10)),
                        child: Text(
                          widget.contact?.name.split(' ').first ?? '',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const Text(
                        "'s Timeline",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: toX(10)),
                    child: uiElements.popupMenu(
                      pageMenuItems(),
                      Image(
                        image: const AssetImage("assets/images/menu_dots.png"),
                        width: toX(32),
                        height: toX(32),
                      ),
                      BoxConstraints.tightFor(width: toX(200)),
                      Offset(0, toY(40)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: toY(250),
            left: toX(10),
            right: toX(60),
            child: Container(
              height: toY(52),
              decoration: BoxDecoration(
                color: Color(0xFF292C35),
                border: Border.all(
                  color: Color(0xFFD3D3D3),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: toX(9), right: toX(8)),
                    child: InkWell(
                      onTap: () {
                        if (_isListening) {
                          _stopListening();
                        } else {
                          _startListening();
                        }
                      },
                      child: SizedBox(
                        width: toX(40),
                        height: toX(40),
                        child: Center(
                          child: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color: _isListening ? Colors.red : Colors.white,
                            size: toX(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const DottedLine(
                    direction: Axis.vertical,
                    lineLength: double.infinity,
                    lineThickness: 1.0,
                    dashLength: 2.0,
                    dashColor: Color(0xFF797878),
                    dashRadius: 0.0,
                    dashGapLength: 2.0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: toX(5)),
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Timeline Search...",
                          hintStyle: TextStyle(
                            color: _textController.text.isEmpty && !_focusNode.hasFocus
                                ? Color(0xFFFFFFFF).withOpacity(0.5)
                                : Color(0xFFFFFFFF),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),


                    ),
                  ),
                  if (_textController.text.length > 4 &&
                      _textController.text.length < 257)
                    GestureDetector(
                      onTap: () async {
                        await _sendRequestToServer();
                      },
                      child: Container(
                        width: toX(40),
                        height: toX(40),
                        decoration: BoxDecoration(
                          color: Color(0xFF292C35),
                          border: Border.all(
                            color: Color(0xFFD3D3D3),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, top: 1, right: 5, bottom: 5),
                          child: Image.asset(
                            'assets/images/AlexAI.png',
                            width: toX(30),
                            height: toX(34),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: toY(250),
            right: toX(10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _textController.clear();
                });
              },
              child: Container(
                width: toX(40),
                height: toX(40),
                decoration: BoxDecoration(
                  color: Color(0xFF292C35),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/search_clean.png',
                    width: toX(24),
                    height: toX(24),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: toY(300),
            left: toX(10),
            right: toX(10),
            bottom: toY(20),
            child: ListView(
              controller: _scrollController,
              children: buildInteractionListWithDates(
                  getSortedInteractions(interactions)),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _sendRequestToServer() async {
    try {
      // Get contact's phone number and UUID
      String? contactPhoneNumber = widget.contact?.phoneNumber;
      contactPhoneNumber = '972' + contactPhoneNumber!.substring(1);
      String? userUuid = applicationModel.currentContact?.user?.uuid;

      // Create the URI with query parameters
      Uri uri = Uri.http(baseUrl, '/user/summary', {
        'uuid': userUuid,
        'query': _textController.text,
        'from': contactPhoneNumber,
      });

      // Send HTTP GET request
      final httpResponse = await http.get(uri);

      if (httpResponse.statusCode == StatusCode.OK) {
        final response = jsonDecode(httpResponse.body);

        if (response is List) {
          setState(() {
            interactions = (response as List<dynamic>)
                .map((item) {
              InteractionDirection direction = item['direction'] == 'outgoing'
                  ? InteractionDirection.outgoing
                  : InteractionDirection.incoming;

              String address = direction == InteractionDirection.incoming
                  ? widget.contact?.phoneNumber
                  : item['phoneNumber']; // Adjust as necessary

              // Determine member details based on interaction direction
              members member = direction == InteractionDirection.outgoing
                  ? members(
              //  fName: widget.contact?.user?.username ?? '', // Use an empty string if null
                lName: applicationModel.currentContact?.user?.username ?? '', // Use an empty string if null
              )
                  : members(
                fName: widget.contact?.convertedFirstName, // Use an empty string if null
                lName:  widget.contact?.convertedLastName ?? '', // Use an empty string if null
              );


              return DefaultInteraction(
                sourceName: 'WhatsApp', // Always "WhatsApp"
                createdDateTime: DateTime.parse(item['createdDateTime']),
                meetingTitle: item['meetingTitle'],
                address: address, // Set the address based on direction
                direction: direction,
                Member: member, // Set the member based on direction
                summary: item['summary'],
                color: getRandomColor(), // Assign color at creation
              );
            })
                .toList();
          });
        } else {
          print('Unexpected data format: ${response['data']}');
        }
      } else {
        print('Failed to load data: ${httpResponse.body}');
      }
    } catch (err) {
      print('Error occurred: $err');
    }
  }


  List<DefaultInteraction> getSortedInteractions(
      List<DefaultInteraction> interactions) {
    List<DefaultInteraction> sortedInteractions = List.from(interactions);

    sortedInteractions.sort((a, b) {
      return b.createdDateTime!.compareTo(a.createdDateTime!);
    });

    return sortedInteractions;
  }

  List<Widget> buildInteractionListWithDates(List<DefaultInteraction> sortedInteractions) {
    DateTime? lastDate;
    List<Widget> widgets = [];

    for (int i = 0; i < sortedInteractions.length; i++) {
      DefaultInteraction interaction = sortedInteractions[i];
      DateTime interactionDate = interaction.createdDateTime!;

      if (lastDate == null || !isSameDay(interactionDate, lastDate)) {
        String dateText = DateFormat('dd/MM/yy').format(interactionDate);
        widgets.add(TimelineSeparator(dateText: dateText));
      }

      widgets.add(SizedBox(height: toY(18)));

      Widget interactionWidget = GestureDetector(
        onTap: () => toggleReadStatus(interaction),
        child: buildDefaultInteraction(context, interaction),
      );
      widgets.add(interactionWidget);

      if (i + 1 < sortedInteractions.length) {
        DateTime nextInteractionDate =
            sortedInteractions[i + 1].createdDateTime!;
        if (isSameDay(interactionDate, nextInteractionDate)) {
          widgets.add(SizedBox(height: toY(18)));
        }
      }

      lastDate = interactionDate;
    }

    return widgets;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void toggleReadStatus(DefaultInteraction interaction) {
    setState(() {
      interaction.isUnread = false;
    });
  }

  Widget buildDefaultInteraction(BuildContext context, DefaultInteraction interaction) {
    BorderRadiusGeometry borderRadius;
    EdgeInsetsGeometry margin;
    Color borderColor = getBorderColor(interaction.sourceName);
    double offsetX;
    if (interaction.direction == InteractionDirection.outgoing) {
      offsetX = -5;
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      );
      margin = EdgeInsets.only(left: 22);
    } else {
      offsetX = -2;
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(0),
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      );
      margin = EdgeInsets.only(right: 22);
    }

    return Align(
        child: Container(
      width: 365.5,
      margin: margin,
      decoration: BoxDecoration(
        color: Color(0xFF131621),
        border: Border.all(color: borderColor, width: 3),
        borderRadius: borderRadius,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 15),
                child: _buildDefaultHeader(interaction),
              ),
              SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 15),
                    child: interaction.Member.image != null &&
                            interaction.Member.image!.isNotEmpty
                        ? Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Image.asset(
                              interaction.Member.image!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: interaction.color, // Use the cached color
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: Text(
                                interaction.Member.initials(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFB7B7B7),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12, left: 10),
                          child: Text(
                            interaction.Member.Company != null &&
                                    interaction.Member.Company!.isNotEmpty
                                ? "${interaction.Member.fName ?? ''} ${interaction.Member.lName ?? ''} - ${interaction.Member.Company}"
                                    .trim()
                                : "${interaction.Member.fName ?? ''} ${interaction.Member.lName}"
                                    .trim(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 10),
                          child: Container(
                            width: 270,
                            child: Text(
                              "${interaction.summary ?? ''}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFB7B7B7),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (interaction.tags?.isNotEmpty ?? false)
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: buildMemberTags(interaction),
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20, right: 10, bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/timeline_clock.png',
                        width: 10,
                        height: 10,
                      ),
                      SizedBox(width: 4),
                      Text(
                        DateFormat('HH:mm - dd/MM/yy')
                            .format(interaction.createdDateTime!),
                        style: TextStyle(
                          fontSize: 8,
                          color: Color(0xFFB7B7B7),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (interaction.sourceName == 'WhatsApp')
            Positioned(
              left: 0,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(offsetX, 4),
                child: Image.asset(
                  'assets/images/whatsapp_timeline_screen.png',
                  width: 15,
                  height: 15,
                ),
              ),
            ),
          if (interaction.sourceName == 'Email')
            Positioned(
              left: 0,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(offsetX, 4),
                child: Image.asset(
                  'assets/images/Email_timeline.png',
                  width: 15,
                  height: 15,
                ),
              ),
            ),
          if (interaction.sourceName == 'SMS')
            Positioned(
              left: 0,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(offsetX, 4),
                child: Image.asset(
                  'assets/images/sms_timeline.png',
                  width: 15,
                  height: 15,
                ),
              ),
            ),
          if (interaction.isUnread)
            Positioned(
              right: (interaction.tags?.isNotEmpty ?? false) ? 30 : 10,
              top: 10,
              child: Image.asset(
                'assets/images/timeline_unread.png',
                width: 15,
                height: 15,
              ),
            ),
          if (interaction.tags?.isNotEmpty ?? false)
            Positioned(
              right: 10,
              top: 10,
              child: Image.asset(
                'assets/images/tag_sign.png',
                width: 15,
                height: 15,
              ),
            ),
        ],
      ),
    ));
  }

  Widget _buildDefaultHeader(DefaultInteraction interaction) {
    String source = interaction.sourceName == 'WhatsApp'
        ? 'Whatsapp - '
        : interaction.sourceName == 'Email'
            ? 'Email - '
            : 'Messages(SMS) - ';
    String directionText =
        interaction.direction == InteractionDirection.incoming
            ? 'Incoming'
            : 'Outgoing';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          Text(
            "$source$directionText",
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFFB7B7B7),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              interaction.address,
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFFFFFFFF),
                decoration: TextDecoration.none,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMemberTags(Interaction interaction) {
    List<Widget> getMemberWidgets() {
      List<Widget> memberWidgets = [];
      int displayLimit =
          interaction.tags!.length > 8 ? 7 : interaction.tags!.length;
      for (int i = 0; i < displayLimit; i++) {
        var member = interaction.tags![i];
        Widget memberWidget;

        if (member.image != null && member.image!.isNotEmpty) {
          memberWidget = Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
            ),
            child: Image.asset(
              member.image!,
              fit: BoxFit.cover,
            ),
          );
        } else {
          memberWidget = Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: getRandomColor(),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Center(
              child: Text(
                member.initials(),
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFFB7B7B7),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          );
        }

        memberWidgets.add(memberWidget);

        if (i < displayLimit - 1 && (i + 1) % 4 != 0) {
          memberWidgets.add(SizedBox(width: 10));
        } else if ((i + 1) % 4 == 0 && i < displayLimit - 1) {
          memberWidgets.add(SizedBox(height: 10));
        }
      }

      if (interaction.tags!.length > 8) {
        memberWidgets.add(SizedBox(width: 10));
        memberWidgets.add(
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Center(
              child: Text(
                '+${interaction.tags!.length - 7}',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C0C0C),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        );
      }

      return memberWidgets;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 59, top: 15),
          child: Text(
            "The Tagged Member",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 70, top: 10),
          child: Container(
            width: 118,
            child: Wrap(
              runSpacing: 10,
              children: getMemberWidgets(),
            ),
          ),
        ),
      ],
    );
  }

  Color getBorderColor(String source) {
    switch (source) {
      case "Email":
        return Color(0xFFC52528);
      case "WhatsApp":
        return Color(0xFF25D366);
      case "SMS":
        return Color(0xFFE8B606);
      default:
        return Color(0xFF06A4E8);
    }
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  List<PopupMenuItem> pageMenuItems() {
    List<PopupMenuItem> list = <PopupMenuItem>[];

    return list;
  }
  void _startListening() async {
    // Initialize the speech-to-text service
    bool available = await _speech.initialize(
      onStatus: (val) {
        print('onStatus: $val');
        if (val == 'listening') {
          print('Listening started successfully');
        } else if (val == 'done') {
          _stopListening();
          print('Recognition done');
        }
      },
      onError: (val) {
        print('onError: $val');  // Log any errors that occur during speech recognition
        setState(() => _isListening = false);
      },
    );

    if (!available) {
      print("Speech recognition not available");  // Log if speech recognition is not available
      return;
    } else {
      print("Speech recognition is available and initialized");
    }

    // Start listening if available
    setState(() => _isListening = true);
    _speech.listen(
      onResult: (val) {
        print("onResult callback triggered");  // Check if onResult is triggered
        setState(() {
          _lastWords = val.recognizedWords;
          print("Recognized words: $_lastWords");  // Log the recognized words
          _textController.text = _lastWords;
        });
      },
      listenFor: Duration(seconds: 15),  // Set a longer listening duration if needed
      pauseFor: Duration(seconds: 5),  // Set pause duration
      cancelOnError: true,  // Cancel the listening if an error occurs
      partialResults: false,  // Disable partial results
    );
    print("Listening now...");
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
    print("Stopped listening.");
  }



}
