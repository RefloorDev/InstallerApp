import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reflore/common/button/my_button.dart';
import 'package:reflore/common/dialog/common_dialog.dart';
import 'package:reflore/common/label/item_label_text.dart';
import 'package:reflore/common/textfield/my_text_field.dart';
import 'package:reflore/common/utilites/logger.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';
import 'package:reflore/common/utilites/strings.dart';
import 'package:reflore/model/appointment_data.dart';
import 'package:reflore/model/checklist_data.dart';
import 'package:reflore/model/invoice_data.dart';
import 'package:reflore/pages/installer/bloc/installer_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

Future invoiceFullDialog(BuildContext context,AppointmentData data,InstallerDetailsBloc bloc, Function(bool isVerify) onClick) {
  final TextEditingController projectType=TextEditingController();
  final TextEditingController customerName=TextEditingController();
  final TextEditingController contractorName=TextEditingController();
  final TextEditingController amount=TextEditingController();
  final TextEditingController date=TextEditingController();


  return showGeneralDialog(
    context: context,
    barrierColor: RefloreColors.login_border_color,
    barrierDismissible: false,
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (context, __, ___) {

      return Scaffold(
        backgroundColor: RefloreColors.login_border_color,
        appBar: AppBar(
          backgroundColor: RefloreColors.toolbarColor,
          centerTitle: true,

          title: ItemLabelText(
              text:Strings.invoiceSubmission,
              fontSize: 16.0,
              fontWight: FontWeight.w600,
              isFont: true,
              fontColor: Colors.white),
        ),
        body: Padding(
          padding:  EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: StreamBuilder<InvoiceData>(
              initialData: null,
              stream: bloc.invoiceDetailsData,
              builder: (context, si) {

                if(si.data!=null){
                  projectType.text=si.data!.type ?? '';
                  customerName.text=si.data!.customerName ?? '';
                  contractorName.text=si.data!.installationCrewName ?? '';
                  amount.text=(si.data!.laborBillAmount!=null)?si.data!.laborBillAmount.toString():'';
                  //date.text=DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
                }
                return Column(
                  children: [
                    ItemLabelText(text: 'Fill the fields below to submit your invoice for the completed work.',fontWight: FontWeight.w500,fontSize: 16.0,fontColor: Colors.white,isFont: true,textAlignment: TextAlign.center,),
                    SizedBox(height: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemLabelText(text: 'Project Type',fontColor: Colors.white,fontSize: 14.0,fontWight: FontWeight.w500,),
                        SizedBox(height: 1,),
                        TextField(
                          controller: projectType,
                          readOnly: true,
                          style: TextStyle(color: Colors.white54,fontSize: 14.0,fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            filled: true,

                            fillColor: RefloreColors.login_fields_color,
                            focusColor: RefloreColors.login_fields_color,
                            focusedBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 5.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 5.0),
                               borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 5.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Project Type',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemLabelText(text: 'Customer Name',fontColor: Colors.white,fontSize: 14.0,fontWight: FontWeight.w500,),
                        SizedBox(height: 1,),
                        TextField(
                          controller: customerName,
                          readOnly: true,
                          style: TextStyle(color: Colors.white54,fontSize: 14.0,fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: RefloreColors.login_fields_color,
                            focusColor: RefloreColors.login_fields_color,
                            focusedBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 2.0),
                               borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Customer Name',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemLabelText(text: 'Contractor Name',fontColor: Colors.white,fontSize: 14.0,fontWight: FontWeight.w500,isFont: true,),
                        SizedBox(height: 1,),
                        TextField(
                          controller: contractorName,
                          readOnly: true,
                          style: TextStyle(color: Colors.white54,fontSize: 14.0,fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            filled: true,

                            fillColor: RefloreColors.login_fields_color,
                            focusColor: RefloreColors.login_fields_color,
                            focusedBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 5.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 5.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 5.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Contractor Name',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemLabelText(text: 'Total Invoice Amount Requested',isFont:true,fontColor: Colors.white,fontSize: 14.0,fontWight: FontWeight.w500,),
                        SizedBox(height: 1,),
                        TextField(
                          controller: amount,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),  // Allows decimal input
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')) // Only allows numbers and one decimal point, max 2 decimals
                          ],
                          style: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            filled: true,
                            prefixText: '\$',
                            fillColor: RefloreColors.login_fields_color,
                            focusColor: RefloreColors.login_fields_color,
                            focusedBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Total Invoice Amount Requested',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101));
                        if (picked != null) {
                          date.text=DateFormat('dd-MM-yyyy').format(picked);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ItemLabelText(text: 'Date Completed',isFont:true,fontColor: Colors.white,fontSize: 14.0,fontWight: FontWeight.w500,),
                          SizedBox(height: 1,),
                          TextField(
                            controller: date,
                            readOnly: true,
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now());
                              if (picked != null) {
                                date.text=DateFormat('MM/dd/yyyy').format(picked);
                              }
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: RefloreColors.login_fields_color,
                              focusColor: RefloreColors.login_fields_color,
                              focusedBorder: OutlineInputBorder(
                                borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: OutlineInputBorder(
                                borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:  BorderSide(color:  RefloreColors.login_border_color, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Date Completed',
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    StreamBuilder<bool>(
                        initialData: false,
                        stream: bloc!.isSave,
                        builder: (context, s) {
                          return InkWell(
                            onTap: (){
                              bloc!.addIsSave.add(s.data==true?false:true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder<bool>(
                                    initialData: false,
                                    stream: bloc.isSave,
                                    builder: (context, c) {
                                      return Checkbox(value: c.data, onChanged: (val){
                                        bloc.addIsSave.add(val!);
                                      },activeColor: RefloreColors.app_color);
                                    }
                                ),
                                //SvgPicture.asset('assets/icons/uncheck.svg'),
                                const SizedBox(width: 5,),
                                Flexible(child: ItemLabelText(text: 'I Acknowledge the above information is correct and the contracted work is completed as per work order',fontColor: Colors.white,fontSize: 16.0,isFont: true,fontWight: FontWeight.w400,))
                              ],
                            ),
                          );
                        }
                    ),


                  ],
                );
              }
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: RefloreColors.login_border_color,
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
          ),

          width: Get.width,
          margin: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<bool>(
                  initialData: false,
                  stream: bloc.isSave,
                  builder: (context, c) {
                  return GestureDetector(
                    onTap: (){

                      if(c.data!){
                        if(amount.text.isNotEmpty){
                          if(date.text.isNotEmpty){
                            bloc!.sendInvoiceAmount(amount.text);
                           // onClick(true);
                            Navigator.of(context).pop();
                          }else{
                            commonDialog(context, "Please select date", Strings.ok, () {});
                          }

                        }else{
                          commonDialog(context, "Please enter total invoice amount", Strings.ok, () {});

                        }

                      }else{
                        commonDialog(context, "Please check the box to proceed", Strings.ok, () {});

                      }
                   /*   if(c.data==true&&amount.text.isNotEmpty&&date.text.isNotEmpty){
                        onClick(true);
                        Navigator.of(context).pop();

                      }else{
                        commonDialog(context, "Please fill the data", Strings.ok, () {});

                      }*/

                    },
                    child: myButton(
                        width: Get.width * 0.9,
                        height: 55,
                        isChange: 0,
                        child: Padding(
                          padding:
                          const EdgeInsets
                              .all(8.0),
                          child: Center(
                            child: ItemLabelText(
                              text: Strings
                                  .submit,
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
                  );
                }
              )
            ],
          ),
        ),
      );
    },
  );
}
