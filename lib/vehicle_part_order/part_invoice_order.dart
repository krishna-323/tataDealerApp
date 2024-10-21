
import 'package:pdf/widgets.dart';

Future samplePdf()async{
  final pdf = Document();

  pdf.addPage(
    MultiPage(
      margin: EdgeInsets.all(30),
      build: (context) => [
      Text("Sample We Need To Developed This One.")
    ],)
  );
  return pdf.save();
}