import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class RealTimeDbController extends GetxController{
    List<String> brands = [];
    List<String> models = [];
    List<String> addresses = [];
    List<String> issues = [];
    List<String> accessories = [];

    FirebaseDatabase database = FirebaseDatabase.instance;




  saveData()async{
   try{

     DatabaseReference ref = database.ref("extra_data");
     await ref.set(
       {
         "brands": ["Samsung","sony","oppo","realme","redme","condor"],
         "models": ["s10","9t","s9","p6 pro"],
          "address":["setif","reselma","guidjel"],
          "issues": ["lcd","wifi","cart sim",],
         "accessories":["card sim","card sd","pochette"]
       }
     );

   }catch(e){
     return e;
   }
  }
    updateData({required String field, required List list})async{
      try{

        DatabaseReference ref = database.ref("extra_data");
        await ref.update(
            {
              field: list,
            }
        );

      }catch(e){
        return e;
      }
    }
    readAccessories()async{
      DatabaseReference ref = database.ref('extra_data/accessories');
      var snapshot = await ref.get();
      if(snapshot.exists){
        List accessoriesList = snapshot.value as List;
        for (var accessor in accessoriesList){
          accessories.add(accessor.toString());
        }
      }else{
        return null;
      }
    }
    readBrands()async{
      DatabaseReference ref = database.ref('extra_data/brands');
      var snapshot = await ref.get();
        if(snapshot.exists){
          List brandsList = snapshot.value as List;
          for (var brand in brandsList){
            brands.add(brand.toString());
          }
        }else{
        return null;
        }
    }
    readModels()async{
      DatabaseReference ref = database.ref('extra_data/models');
      var snapshot = await ref.get();
      if(snapshot.exists){
       List modelsList = snapshot.value as List;

       for (var model in modelsList){
           models.add(model.toString());
       }
      }else{

      }
    }
    readAddress()async{
      DatabaseReference ref = database.ref('extra_data/address');
      var snapshot = await ref.get();
      if(snapshot.exists){
        List addressList = snapshot.value as List;

        for (var address in addressList){
          addresses.add(address.toString());
        }
      }else{

      }
    }
    readIssues()async{
      DatabaseReference ref = database.ref('extra_data/issues');
      var snapshot = await ref.get();
      if(snapshot.exists){
        List issuesList = snapshot.value as List;

        for (var issue in issuesList){
          issues.add(issue.toString());

        }
      }else{

      }
    }


}