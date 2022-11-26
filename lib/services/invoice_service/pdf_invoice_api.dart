import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../models/device_model.dart';
import '../../models/store_model.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfReceiptApi {
  static Future<File> generate(
      {required Device device, required Store store}) async {
    final pdf = pw.Document();
    Timestamp postedDateTimeStamp = device.dateTime;
    var postIn = postedDateTimeStamp.toDate();
    String postedDate = '${postIn.year}.${postIn.month}.${postIn.day}';
    String postedTime = '${postIn.hour}: ${postIn.minute}';
    var data = await rootBundle.load("assets/fonts/Montserrat-Medium.ttf");

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Container(
            // margin: const pw.EdgeInsets.only(left: 199.5),

            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        store.name,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14.0,
                            font: pw.Font.ttf(data)),
                      )),
                  pw.Divider(),
                  pw.Text('Nom: ${device.ownerName}',
                      style:
                          pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8)),
                  pw.SizedBox(height: 1 * PdfPageFormat.mm),
                  pw.Text('N-Téléphone: ${device.phone}',
                      style:
                          pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8)),
                  pw.SizedBox(height: 1 * PdfPageFormat.mm),
                  pw.Text('La Marque: ${device.brand}',
                      style:
                          pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8)),
                  pw.SizedBox(height: 1 * PdfPageFormat.mm),
                  pw.Text('Le Modèle: ${device.model}',
                      style:
                          pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8)),
                  pw.SizedBox(height: 1 * PdfPageFormat.mm),
                  pw.Text('La Panne: ${device.issue}',
                      style:
                          pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8)),
                  pw.SizedBox(height: 10 * PdfPageFormat.mm),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text('Date: $postedDate Le: $postedTime',
                        style:
                            pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8)),
                  ),
                  pw.Container(
                      child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Divider(),
                      pw.SizedBox(height: 2 * PdfPageFormat.mm),
                      pw.Text(
                        'Contactez-nous',
                        style:
                            pw.TextStyle(font: pw.Font.ttf(data), fontSize: 10),
                      ),
                      pw.SizedBox(height: 1 * PdfPageFormat.mm),
                      pw.Text(
                        'N-Téléphone: ${store.phone}',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(data),
                            fontSize: 8),
                      ),
                      pw.SizedBox(height: 1 * PdfPageFormat.mm),
                      pw.Text(
                        'Facebook: ${store.facebook}',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(data),
                            fontSize: 8),
                      ),
                      pw.SizedBox(height: 1 * PdfPageFormat.mm),
                      pw.Text(
                        'Adress: ${store.location}',
                        style:
                            pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8),
                      ),
                    ],
                  ))
                ]),
          );
        },
      ),
    );

    return FileHandleApi.saveDocument(name: '${DateTime.now()}', pdf: pdf);
  }
}

class PdfInvoiceApi {
  static Future<File> generateInvoice(
      {required Device device, required String price, required Store store}) async {
    final pdf = pw.Document();
    DateTime dateTime = DateTime.now();
    String postedDate = '${dateTime.year}.${dateTime.month}.${dateTime.day}';
    String postedTime = '${dateTime.hour}: ${dateTime.minute}';
    var data = await rootBundle.load("assets/fonts/Montserrat-Medium.ttf");

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Container(
// margin: const pw.EdgeInsets.only(left: 199.5),

            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        store.name,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10.0,
                            font: pw.Font.ttf(data)),
                      )),
                  pw.Divider(),
                  pw.Text(
                    'Nom: ${device.ownerName}',
                    style: pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8),
                  ),
                  pw.SizedBox(height: 1 * PdfPageFormat.mm),
                  pw.Text('N-Téléphone: ${device.phone}',
                      style:
                          pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8)),
                  pw.SizedBox(height: 1 * PdfPageFormat.mm),
                  pw.Text('La Marque: ${device.brand}',
                      style:
                          pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8)),
                  pw.SizedBox(height: 1 * PdfPageFormat.mm),
                  pw.Text('Le Modèle: ${device.model}',
                      style:
                          pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8)),
                  pw.SizedBox(height: 1 * PdfPageFormat.mm),
                  pw.Text('La Panne: ${device.issue}',
                      style:
                          pw.TextStyle(font: pw.Font.ttf(data), fontSize: 8)),
                  pw.Divider(),
                  pw.Text('Le Prix: $price DA',
                      style: const pw.TextStyle(fontSize: 10)),
                  pw.Divider(color: PdfColors.grey),
                  pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text('$postedDate $postedTime',
                          style: const pw.TextStyle(fontSize: 8)))
                ]),
          );
        },
      ),
    );

    return FileHandleApi.saveDocument(name: '${DateTime.now()}', pdf: pdf);
  }
}
