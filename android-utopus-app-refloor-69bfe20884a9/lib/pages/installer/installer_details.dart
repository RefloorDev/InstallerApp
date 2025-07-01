import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:reflore/app/arch/bloc_provider.dart';
import 'package:reflore/common/button/my_button.dart';
import 'package:reflore/common/dialog/checklist_full_dialog.dart';
import 'package:reflore/common/dialog/invoice_full_dialog.dart';
import 'package:reflore/common/dialog/pdf_full_dialog.dart';
import 'package:reflore/common/load_container/load_container.dart';
import 'package:reflore/common/utilites/logger.dart';
import 'package:reflore/di/app_injector.dart';
import 'package:reflore/di/i_installer_page.dart';
import 'package:reflore/model/appointment_data.dart';
import 'package:reflore/model/checklist_data.dart';
import 'package:reflore/model/file_data.dart';
import 'package:reflore/pages/installer/bloc/installer_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/dialog/buttons_dialog.dart';
import '../../common/dialog/common_dialog.dart';
import '../../common/dialog/upload_dialog.dart';
import '../../common/label/item_label_text.dart';
import '../../common/utilites/common_data.dart';
import '../../common/utilites/reflore_colors.dart';
import '../../common/utilites/strings.dart';

class InstallerDetails extends StatefulWidget {
  const InstallerDetails({super.key});

  @override
  InstallerDetailsState createState() => InstallerDetailsState();
}

class InstallerDetailsState extends State<InstallerDetails> {
  static InstallerDetailsBloc? bloc;
  List<String> str = [
    'Install a “Project Perfect” floor so I never need to return ',
    'Complete all assigned work',
    'Prep surface (subfloors) properly before installation ',
    'Not commit “Flagrant Fouls"',
    'Walk the job with the customer after installation',
    'Do a full inspection with pictures prior to leaving'
  ];
  @override
  void initState() {
    bloc = BlocProvider.of(context);
    validateErrorMsg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: RefloreColors.app_bg,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: RefloreColors.toolbarColor,
          title: ItemLabelText(
              text: Strings.instDetails,
              fontSize: 18.0,
              fontWight: FontWeight.w600,
              isFont: true,
              fontColor: Colors.white),
        ),
        body: LoaderContainer(
          stream: bloc!.isLoading,
          child: SingleChildScrollView(
            child: StreamBuilder<int>(
                initialData: -1,
                stream: bloc!.tabSelect,
                builder: (context, st) {
                  return StreamBuilder<AppointmentData>(
                      initialData: null,
                      stream: bloc!.installerData,
                      builder: (context, snap) {
                        return (snap.data != null)
                            ? Container(
                                margin: const EdgeInsets.all(15),
                                padding: const EdgeInsets.all(10),
                                color: RefloreColors.toolbarColor,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: ItemLabelText(
                                              text: Strings.type,
                                              fontSize: 14.0,
                                              isFont: true,
                                              fontWight: FontWeight.w700,
                                              fontColor: RefloreColors
                                                  .login_icon_color,
                                            )),
                                        Expanded(
                                            flex: 5,
                                            child: ItemLabelText(
                                              text: bloc!.type == 0
                                                  ? Strings.installation
                                                  : Strings.services,
                                              fontSize: 14.0,
                                              isFont: true,
                                              fontWight: FontWeight.w700,
                                              fontColor: Colors.white,
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: ItemLabelText(
                                              text: Strings.projectDates,
                                              fontSize: 14.0,
                                              isFont: true,
                                              fontWight: FontWeight.w700,
                                              fontColor: RefloreColors
                                                  .login_icon_color,
                                            )),
                                        Expanded(
                                            flex: 5,
                                            child: ItemLabelText(
                                              //text: '${bloc!.appointmentData!.startDate} - ${bloc!.appointmentData!.startDate}',
                                              text:
                                                  '${DateFormat('MM/dd/yyyy').format(DateTime.parse((snap.data!.startDate != null) ? snap.data!.startDate! : ""))} - ${DateFormat('MM/dd/yyyy').format(DateTime.parse((snap.data!.endDate != null) ? snap.data!.endDate! : ""))}',
                                              fontSize: 14.0,
                                              isFont: true,
                                              fontWight: FontWeight.w700,
                                              fontColor: Colors.white,
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: ItemLabelText(
                                          text: Strings.customerInformation,
                                          fontSize: 14.0,
                                          isFont: true,
                                          fontWight: FontWeight.w700,
                                          fontColor:
                                              RefloreColors.login_icon_color,
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/user.svg'),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Flexible(
                                          child: ItemLabelText(
                                            text: snap.data!.prospectName!,
                                            fontSize: 14.0,
                                            isFont: true,
                                            fontWight: FontWeight.w500,
                                            fontColor: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        String? address =
                                            '${(snap.data!.prospectFullAddress != null) ? snap.data!.prospectFullAddress : ""}';

                                          final availableMaps =
                                          await MapLauncher.installedMaps;
                                          await showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    ItemLabelText(
                                                      text:'Open with',
                                                      fontWight: FontWeight.w600,fontSize: 16.0,
                                                    ),
                                                    SizedBox(height: 16.0),
                                                    ...availableMaps.map((map) {
                                                      return ListTile(
                                                        title: ItemLabelText(text:map.mapName,fontSize: 14.0,fontWight: FontWeight.w400,),
                                                        onTap: () async {
                                                          Navigator.of(context).pop();  // Close the bottom sheet
                                                          map.showDirections(destination:Coords(double.parse(snap.data!.appointmentLatitude!), double.parse(snap.data!.appointmentLongitude!)),destinationTitle: address,directionsMode: DirectionsMode.driving,);


                                                          /*      if(map.mapType.toString().toLowerCase().contains('google')){
                                                            CommonData.openInGoogleMaps(address);
                                                          }else  if(map.mapType.toString().toLowerCase().contains('apple')){
                                                            CommonData.openInAppleMaps(address);
                                                          }else  if(map.mapType.toString().toLowerCase().contains('waze')){
                                                            CommonData.openInWaze(address);
                                                          }else{
                                                            List<Location> locations =
                                                            await locationFromAddress(
                                                                address);

                                                            if (locations.isNotEmpty) {
                                                              final Location location =
                                                                  locations.first;
                                                              map.showDirections(destination:Coords(location.latitude, location.longitude),destinationTitle: address,directionsMode: DirectionsMode.driving,);


                                                            } else {
                                                              throw 'No coordinates found for the address.';
                                                            }

                                                          }*/
                                                        },
                                                      );
                                                    }).toList(),
                                                  ],
                                                ),
                                              );
                                            },
                                          );



                                        // MapLauncher.launchQuery('${(snap.data!.prospectFullAddress!=null)?snap.data!.prospectFullAddress:""}');
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/icons/loc.svg'),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Flexible(
                                              child: Text(
                                                  snap.data!
                                                          .prospectFullAddress ??
                                                      '',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                          Colors.blue))),

                                          /* ItemLabelText(
                                      text: snap.data!.prospectFullAddress ?? '',
                                      fontSize: 14.0,
                                      isFont: true,
                                      fontWight: FontWeight.w500,
                                      fontColor: Colors.white,
                                    )*/
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (snap.data!.prospectPhoneNumber!
                                                .isNotEmpty &&
                                            snap.data!.prospectPhoneNumber !=
                                                null) {
                                          final call = Uri.parse(snap
                                                  .data!.prospectPhoneNumber!
                                                  .startsWith('+1')
                                              ? "tel:${snap.data!.prospectPhoneNumber}"
                                              : 'tel:+1${snap.data!.prospectPhoneNumber}');
                                          if (await canLaunchUrl(call)) {
                                            launchUrl(call);
                                          } else {
                                            throw 'Could not launch $call';
                                          }
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/call.svg',
                                            color: RefloreColors
                                                .login_border_color,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                              '${(snap.data!.prospectPhoneNumber != null) ? snap.data!.prospectPhoneNumber : ""}',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      Colors.white))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: ItemLabelText(
                                          text: Strings.jobTitle,
                                          fontSize: 14.0,
                                          isFont: true,
                                          fontWight: FontWeight.w700,
                                          fontColor:
                                              RefloreColors.login_icon_color,
                                        )),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: ItemLabelText(
                                        text: bloc!.appointmentData!.name ?? '',
                                        fontSize: 14.0,
                                        isFont: true,
                                        fontWight: FontWeight.w500,
                                        fontColor: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: ItemLabelText(
                                              text: Strings.installCoordinator,
                                              fontSize: 14.0,
                                              isFont: true,
                                              fontWight: FontWeight.w700,
                                              fontColor: RefloreColors
                                                  .login_icon_color,
                                            )),
                                        Expanded(
                                            flex: 5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ItemLabelText(
                                                  text:
                                                      '${bloc!.appointmentData!.projectCoordinator}',
                                                  textAlignment:
                                                      TextAlign.start,
                                                  fontSize: 14.0,
                                                  isFont: true,
                                                  fontWight: FontWeight.w700,
                                                  fontColor: Colors.white,
                                                ),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (bloc!
                                                              .appointmentData!
                                                              .projectCoordinatorPhone!
                                                              .isNotEmpty &&
                                                          bloc!.appointmentData!
                                                                  .projectCoordinatorPhone !=
                                                              null) {
                                                        final call = Uri.parse(bloc!
                                                                .appointmentData!
                                                                .projectCoordinatorPhone!
                                                                .startsWith(
                                                                    '+1')
                                                            ? "tel:${bloc!.appointmentData!.projectCoordinatorPhone}"
                                                            : 'tel:+1${bloc!.appointmentData!.projectCoordinatorPhone}');
                                                        if (await canLaunchUrl(
                                                            call)) {
                                                          launchUrl(call);
                                                        } else {
                                                          throw 'Could not launch $call';
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                        '${(bloc!.appointmentData!.projectCoordinatorPhone != null) ? bloc!.appointmentData!.projectCoordinatorPhone : ""}',
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                Colors.white))),
                                              ],
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: ItemLabelText(
                                              text: Strings
                                                  .installCoordinatorManager,
                                              fontSize: 14.0,
                                              isFont: true,
                                              fontWight: FontWeight.w700,
                                              fontColor: RefloreColors
                                                  .login_icon_color,
                                            )),
                                        Expanded(
                                            flex: 5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ItemLabelText(
                                                  text:
                                                      '${bloc!.appointmentData!.installCoordinatorManager}',
                                                  textAlignment:
                                                      TextAlign.start,
                                                  fontSize: 14.0,
                                                  isFont: true,
                                                  fontWight: FontWeight.w700,
                                                  fontColor: Colors.white,
                                                ),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (bloc!
                                                              .appointmentData!
                                                              .installCoordinatorManagerPhone!
                                                              .isNotEmpty &&
                                                          bloc!.appointmentData!
                                                                  .installCoordinatorManagerPhone !=
                                                              null) {
                                                        final call = Uri.parse(bloc!
                                                                .appointmentData!
                                                                .installCoordinatorManagerPhone!
                                                                .startsWith(
                                                                    '+1')
                                                            ? "tel:${bloc!.appointmentData!.installCoordinatorManagerPhone}"
                                                            : 'tel:+1${bloc!.appointmentData!.installCoordinatorManagerPhone}');

                                                        //final call = Uri.parse('tel:+${data.projectCoordinatorPhone}');
                                                        if (await canLaunchUrl(
                                                            call)) {
                                                          launchUrl(call);
                                                        } else {
                                                          throw 'Could not launch $call';
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                        '${(bloc!.appointmentData!.installCoordinatorManagerPhone != null) ? bloc!.appointmentData!.installCoordinatorManagerPhone : ""}',
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                Colors.white)))
                                              ],
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    /* Align(
                                alignment: Alignment.centerLeft,
                                child: ItemLabelText(text: Strings.refloorOperations,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:RefloreColors.login_icon_color ,)),
                            const SizedBox(height: 15,),*/
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: ItemLabelText(
                                              text: Strings.installManager,
                                              fontSize: 14.0,
                                              isFont: true,
                                              fontWight: FontWeight.w700,
                                              fontColor: RefloreColors
                                                  .login_icon_color,
                                            )),
                                        Expanded(
                                            flex: 5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ItemLabelText(
                                                  text:
                                                      '${bloc!.appointmentData!.installationManager}',
                                                  textAlignment:
                                                      TextAlign.start,
                                                  fontSize: 14.0,
                                                  isFont: true,
                                                  fontWight: FontWeight.w700,
                                                  fontColor: Colors.white,
                                                ),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (bloc!
                                                              .appointmentData!
                                                              .installationManagerPhone!
                                                              .isNotEmpty &&
                                                          bloc!.appointmentData!
                                                                  .installationManagerPhone !=
                                                              null) {
                                                        final call = Uri.parse(bloc!
                                                                .appointmentData!
                                                                .installationManagerPhone!
                                                                .startsWith(
                                                                    '+1')
                                                            ? "tel:${bloc!.appointmentData!.installationManagerPhone}"
                                                            : 'tel:+1${bloc!.appointmentData!.installationManagerPhone}');

                                                        //final call = Uri.parse('tel:+${data.projectCoordinatorPhone}');
                                                        if (await canLaunchUrl(
                                                            call)) {
                                                          launchUrl(call);
                                                        } else {
                                                          throw 'Could not launch $call';
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                        '${(bloc!.appointmentData!.installationManagerPhone != null) ? bloc!.appointmentData!.installationManagerPhone : ""}',
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                Colors.white)))
                                              ],
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: ItemLabelText(
                                          text: Strings.jobDetails,
                                          fontSize: 14.0,
                                          isFont: true,
                                          fontWight: FontWeight.w700,
                                          fontColor:
                                              RefloreColors.login_icon_color,
                                        )),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: ItemLabelText(
                                            text:
                                                bloc!.appointmentData!.comments,
                                            fontSize: 14.0,
                                            fontColor: Colors.white,
                                            isFont: true)),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: ItemLabelText(
                                          text: Strings.confirming,
                                          fontSize: 14.0,
                                          isFont: true,
                                          fontWight: FontWeight.w700,
                                          fontColor:
                                              RefloreColors.login_icon_color,
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: str.map((s) {
                                        return Column(
                                          children: [
                                            Row(children: [
                                              ItemLabelText(
                                                text: "\u2022",
                                                fontSize: 14.0,
                                                fontColor: Colors.white,
                                              ), //bullet text
                                              const SizedBox(
                                                width: 10,
                                              ), //space between bullet and text
                                              Expanded(
                                                child: ItemLabelText(
                                                    text: s,
                                                    fontSize: 14.0,
                                                    fontColor: Colors.white,
                                                    isFont: true,
                                                    fontWight:
                                                        FontWeight.w500), //text
                                              )
                                            ]),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (bloc!.type == 0)
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    if (bloc!.type == 0)
                                      GestureDetector(
                                        onTap: () {
                                          bloc!.addTabSelect.add(0);
                                          bloc!.addIsArrival.add(false);
                                          if (snap.data!.picklistReportURL !=
                                                  null &&
                                              snap.data!.picklistReportURL!
                                                  .isNotEmpty) {
                                            viewPDFPage(
                                                snap.data!.picklistReportURL!,
                                                Strings.pickList);
                                          } else {
                                            Get.snackbar(
                                              "Error",
                                              "${Strings.pickList} not available",
                                              colorText: Colors.white,
                                              backgroundColor: Colors.red,
                                              icon: const Icon(Icons
                                                  .notifications_active_outlined),
                                            );
                                          }
                                        },
                                        child: myButton(
                                            width: Get.width,
                                            height: 57,
                                            isChange: st.data == 0 ? 1 : 0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Row(
                                                children: [
                                                  ItemLabelText(
                                                    text:
                                                        ' 1. ${Strings.pickList}',
                                                    fontColor: Colors.white,
                                                    fontWight: FontWeight.w600,
                                                    isFont: true,
                                                    fontSize: 16.0,
                                                  ),
                                                  const Spacer(),
                                                  SvgPicture.asset(
                                                      'assets/icons/pdf.svg')
                                                ],
                                              ),
                                            )),
                                      ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        bloc!.addTabSelect.add(1);
                                        buttonsDialog(
                                            context,
                                            Strings.confirmArrival,
                                            Strings.yes,
                                            Strings.cancel, (type) {
                                          if (type == 0) {
                                            bloc!.confirmArrival(context);
                                          } else {
                                            bloc!.addIsArrival.add(false);
                                          }
                                        });
                                      },
                                      child: myButton(
                                          width: Get.width,
                                          height: 57,
                                          isChange: st.data == 1 ? 1 : 0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Row(
                                              children: [
                                                ItemLabelText(
                                                  text:
                                                      '${(bloc!.type == 0) ? "2. " : "1. "}${Strings.confirmYourArrival}',
                                                  fontColor: Colors.white,
                                                  fontWight: FontWeight.w600,
                                                  isFont: true,
                                                  fontSize: 16.0,
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          )),
                                    ),
                                    StreamBuilder<List<FileData>>(
                                        initialData: [],
                                        stream:  bloc!.uploadFiles,
                                        builder: (b,sf){
                                          return    StreamBuilder<bool>(
                                              initialData: false,
                                              stream: bloc!.isArrival,
                                              builder: (b, si) {
                                                return (si.data == true ||sf.data!.isNotEmpty)
                                                    ? Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    /*ItemLabelText(text: Strings.confirmAgree,isFont: true,fontSize: 16.0,fontWight: FontWeight.w400,fontColor: Colors.white,),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      StreamBuilder<bool>(
                                          initialData: false,
                                          stream: bloc!.workOrder,
                                          builder: (context, s) {
                                            return InkWell(
                                              onTap: (){
                                                bloc!.addWorkOrder.add(s.data==true?false:true);
                                              },
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset('assets/icons/uncheck.svg'),
                                                  const SizedBox(width: 10,),
                                                  ItemLabelText(text: Strings.workOrder,fontColor: Colors.white,fontSize: 16.0,isFont: true,fontWight: FontWeight.w400,)
                                                ],
                                              ),
                                            );
                                          }
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      StreamBuilder<bool>(
                                          initialData: false,
                                          stream: bloc!.leveling,
                                          builder: (context, s) {
                                            return InkWell(
                                              onTap: (){
                                                bloc!.addLeveling.add(s.data==true?false:true);
                                              },
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset('assets/icons/uncheck.svg'),
                                                  const SizedBox(width: 10,),
                                                  ItemLabelText(text: Strings.properLeveling,fontColor: Colors.white,fontSize: 16.0,isFont: true,fontWight: FontWeight.w400,)
                                                ],
                                              ),
                                            );
                                          }
                                      ),*/
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                    StreamBuilder<bool>(
                                                      initialData: false,
                                                      stream: bloc!.isArrivalCheck,
                                                      builder: (context, si) {
                                                        return (!si.data!)?GestureDetector(
                                                          onTap: () {
                                                            bloc!.arrvialCheck();
                                                            checklistDialog(context,bloc!,0,(value){
                                                              bloc!.addArrivalCheck.add(value);

                                                            });
                                                          },
                                                          child: Center(
                                                            child: myButton(
                                                                width:
                                                                Get.width * 0.7,
                                                                height: 42,
                                                                isChange: 0,
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                                  child: Center(
                                                                    child: ItemLabelText(
                                                                      text: Strings
                                                                          .arrivalChecklist,
                                                                      fontColor:
                                                                      Colors
                                                                          .white,
                                                                      fontWight:
                                                                      FontWeight
                                                                          .w600,
                                                                      isFont:
                                                                      true,
                                                                      fontSize:
                                                                      16.0,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                        ): GestureDetector(
                                                          onTap: () {
                                                            uploadDialog(
                                                                context,
                                                                InstallerDetailsState
                                                                    .bloc!,
                                                                    () {});
                                                          },
                                                          child: Center(
                                                            child: myButton(
                                                                width:
                                                                Get.width * 0.7,
                                                                height: 42,
                                                                isChange: 0,
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      ItemLabelText(
                                                                        text: Strings
                                                                            .arrivalPhoto,
                                                                        fontColor:
                                                                        Colors
                                                                            .white,
                                                                        fontWight:
                                                                        FontWeight
                                                                            .w600,
                                                                        isFont:
                                                                        true,
                                                                        fontSize:
                                                                        16.0,
                                                                      ),
                                                                      const Spacer(),
                                                                      SvgPicture.asset(
                                                                          'assets/icons/upload.svg')
                                                                    ],
                                                                  ),
                                                                )),
                                                          ),
                                                        );
                                                      }
                                                    ),



                                                  ],
                                                )
                                                    : const SizedBox();
                                              });
                                        }),

                                    const SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (snap.data!.saleSummaryReportURL !=
                                                null &&
                                            snap.data!.saleSummaryReportURL!
                                                .isNotEmpty) {
                                          bloc!.addTabSelect.add(2);
                                          viewPDFPage(
                                              snap.data!.saleSummaryReportURL!,
                                              Strings.salesSummaryReport);
                                        } else {
                                          Get.snackbar(
                                            "Error",
                                            "${Strings.salesSummaryReport} not available",
                                            colorText: Colors.white,
                                            backgroundColor: Colors.red,
                                            icon: const Icon(Icons
                                                .notifications_active_outlined),
                                          );
                                        }

                                        bloc!.addIsArrival.add(false);
                                      },
                                      child: myButton(
                                          width: Get.width,
                                          height: 57,
                                          isChange: st.data == 2 ? 1 : 0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Row(
                                              children: [
                                                ItemLabelText(
                                                  text:
                                                      '${(bloc!.type == 0) ? "3. " : '2. '}${Strings.salesSummaryReport}',
                                                  fontColor: Colors.white,
                                                  fontWight: FontWeight.w600,
                                                  isFont: true,
                                                  fontSize: 16.0,
                                                ),
                                                const Spacer(),
                                                SvgPicture.asset(
                                                    'assets/icons/pdf.svg')
                                              ],
                                            ),
                                          )),
                                    ),
                                    if (bloc!.type == 0)
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    if (bloc!.type == 0)
                                      GestureDetector(
                                        onTap: () {
                                          bloc!.addTabSelect.add(3);
                                          bloc!.addIsArrival.add(false);
                                          if (snap.data!.laborBillReportURL !=
                                                  null &&
                                              snap.data!.laborBillReportURL!
                                                  .isNotEmpty) {
                                            viewPDFPage(
                                                snap.data!.laborBillReportURL!,
                                                Strings.laborBill);
                                          } else {
                                            Get.snackbar(
                                              "Error",
                                              "${Strings.laborBill} not available",
                                              colorText: Colors.white,
                                              backgroundColor: Colors.red,
                                              icon: const Icon(Icons
                                                  .notifications_active_outlined),
                                            );
                                          }
                                        },
                                        child: myButton(
                                            width: Get.width,
                                            height: 57,
                                            isChange: st.data == 3 ? 1 : 0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Row(
                                                children: [
                                                  ItemLabelText(
                                                    text:
                                                        '4. ${Strings.laborBill}',
                                                    fontColor: Colors.white,
                                                    fontWight: FontWeight.w600,
                                                    isFont: true,
                                                    fontSize: 16.0,
                                                  ),
                                                  const Spacer(),
                                                  SvgPicture.asset(
                                                      'assets/icons/pdf.svg')
                                                ],
                                              ),
                                            )),
                                      ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    StreamBuilder<bool>(
                                      initialData: false,
                                      stream: bloc!.isCompleteCheck,
                                      builder: (context, sc) {
                                        return StreamBuilder<bool>(
                                          initialData: false,
                                          stream: bloc!.isInvoice,
                                          builder: (context, si) {
                                            return GestureDetector(
                                              onTap: () {
                                                bloc!.setCompleteList();
                                                bloc!.addTabSelect.add(4);
                                                bloc!.addIsArrival.add(false);
                                                if (bloc!.isConfirmArrivalCompleted) {

                                                  if(sc.data!){
                                                     if(si.data!){
                                                       Get.to(AppInjector.instance
                                                           .completeInstallation(
                                                           bloc!.type!,
                                                           bloc!.appointmentData,
                                                           bloc!.lastUpload, (list) {
                                                         bloc!.lastUpload = list;
                                                       }))!
                                                           .then((val) {});
                                                     }else{
                                                       invoiceFullDialog(context,bloc!.appointmentData!,bloc!,(value) async {
                                                         bloc!.addIsInvoice.add(value);
                                                         Get.to(AppInjector.instance
                                                             .completeInstallation(
                                                             bloc!.type!,
                                                             bloc!.appointmentData,
                                                             bloc!.lastUpload, (list) {
                                                           bloc!.lastUpload = list;
                                                         }))!.then((val) {});
                                                       });
                                                     }

                                                  }else{
                                                    checklistDialog(context,bloc!,1,(value) async {
                                                      bloc!.addCompleteCheck.add(value);
                                                      await Future.delayed(Duration(seconds: 1));
                                                      invoiceFullDialog(context,bloc!.appointmentData!,bloc!,(value){

                                                      });
                                                    });
                                                  }



                                                } else {
                                                  commonDialog(context,"Please upload the photos to complete installation",Strings.ok,(){

                                                  });
                                                  /*Get.snackbar(
                                                    "Error",
                                                    "Please upload the photos to complete installation",
                                                    colorText: Colors.white,
                                                    backgroundColor: Colors.red,
                                                    icon: const Icon(
                                                      Icons.error_outline,
                                                      color: Colors.white,
                                                    ),
                                                  );*/
                                                }
                                              },
                                              child: myButton(
                                                  width: Get.width,
                                                  height: 57,
                                                  isChange: st.data == 4 ? 1 : 0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 8.0, right: 8.0),
                                                    child: Row(
                                                      children: [
                                                        ItemLabelText(
                                                          text:
                                                              '${(bloc!.type == 0) ? "5. " : "3. "}${'Complete ${bloc!.appointmentData!.activityType == "Service" ? "Service" : 'Installation'}'}',
                                                          fontColor: Colors.white,
                                                          fontWight: FontWeight.w600,
                                                          isFont: true,
                                                          fontSize: 16.0,
                                                        ),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                  )),
                                            );
                                          }
                                        );
                                      }
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox();
                      });
                }),
          ),
        ));
  }

  void viewPDFPage(String URL, String title) async {
    if (URL != null || URL.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => PdfFullDialog(
            pdfPath: URL,
            title: title,
          ),
        ),
      );
/*      bloc!.addIsLoading.add(true);
      Completer<File> completer = Completer();
      print("Start download file from internet!");
      try {
        final url = URL;
        final filename = url.substring(url.lastIndexOf("/") + 1);
        var request = await HttpClient().getUrl(Uri.parse(url));
        var response = await request.close();
        var bytes = await consolidateHttpClientResponseBytes(response);
        var dir = await getApplicationDocumentsDirectory();
        File file = File("${dir.path}/$filename");
        await file.writeAsBytes(bytes, flush: true);
        completer.complete(file);
        bloc!.addIsLoading.add(false);
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => PdfFullDialog(pdfPath:url,title: title,),
          ),
        );
        //pdfDialog(context, () => null, file.path);
      } catch (e) {
        bloc!.addIsLoading.add(false);
        throw Exception('Error parsing asset file!');
      }*/
    }
  }

  void validateErrorMsg() {
    bloc!.errMsg.listen((event) {
      if (event.isNotEmpty) {
        commonDialog(context, event, Strings.ok, () {});
      }
    });
  }
}
