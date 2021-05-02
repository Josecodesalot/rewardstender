import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:rewards_network_shared/widgets/primary_button.dart';
import 'package:rewardstender/view/authenticate_view/widgets/authenticate_injector.dart';
import 'package:rewardstender/view_model/authenticate_model.dart';

class SignUpDialog extends StatefulWidget {
  @override
  _SignUpDialogState createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {
  String get name => model.nameController.text;

  int page = 0;

  AuthenticateModel get model =>
      Provider.of<AuthenticateModel>(context, listen: false);



  @override
  Widget build(BuildContext context) {
    Provider.of<AuthenticateModel>(context, listen: true);
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          height: 500,
          child: Column(
            children: [
              _buildTitle(),
              Expanded(
                child: PageView(
                  controller: model.pageController,
                  onPageChanged: (i) => setState(() => page = i),
                  children: [
                    _nameInput(),
                    _placeSelect(),
                  ],
                ),
              ),
              _mainButton(),
              const SizedBox(height: 20),
              Text('${page + 1}/2'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nameInput() {
    return Center(
      child: TextFormField(
        focusNode: model.focusNode,
        controller: model.nameController,
        autofocus: true,
        decoration: InputDecoration(labelText: 'Name'),
        validator: (val) => val.isNotEmpty ? null : 'Please write your name :)',
        autocorrect: false,
      ),
    );
  }

  Widget _placeSelect() {
    switch (model.state) {
      case PlaceFetchState.unInitiated:
        //TODO add screenshot or info to help user figure this out
        return const SizedBox();
      case PlaceFetchState.loading:
        return Center(
          child: CircularProgressIndicator(),
        );
        break;
      case PlaceFetchState.completed:
        return Center(
          child: Text('${model.publicPlace.placeName}'),
        );
      //TODO handle errors better!
      case PlaceFetchState.failed:
        return Center(
          child: Text('Im sorry something went wrong'),
        );
    }
    return const SizedBox();
  }

  Widget _buildTitle() {
    return Text(
      page == 0
          ? 'Almost done with the sign-up! what is your name?'
          : model.fetchCompleted
              ? 'We found a match! does this look like your place of work?'
              : 'We just how to connect you with your work place before proceeding. Please scan your manager to show you his Clerks QR code from his manager app',
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget _mainButton() {
    return Column(
      children: [
        PrimaryButton(
          title: page == 0 ? 'next' : model.fetchCompleted? 'Accept' :'',
          leadingWidget: page == 1 && !model.fetchCompleted
              ? Icon(Icons.camera_alt_rounded, color: Colors.grey[50])
              : const SizedBox(),
          enabled: name.isAtlest3CharactersLong(),
          onTap: () async {
            if (page == 0) {
              model.focusNode.unfocus();
              await Future.delayed(const Duration(milliseconds: 200));
              model.pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            } else if(page == 2 && !model.fetchCompleted){
              final placeId = await FlutterBarcodeScanner.scanBarcode(
                  '#FFFFFF', 'cancel', true, ScanMode.QR);
              model.findPlace(placeId);
            }else if(model.fetchCompleted && page == 2){
              Navigator.pop(context, true);
            }
          },
        ),

        if(model.fetchCompleted && page ==1)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: PrimaryButton(
              title: 'try again',
              onTap: ()async{
                final placeId = await FlutterBarcodeScanner.scanBarcode(
                    '#FFFFFF', 'cancel', true, ScanMode.QR);
                model.findPlace(placeId);
              },
            ),
          )
      ],
    );
  }
}

///This dialog will return true or false depending on whether the
///operation was successful or not
Widget signUpDialog(BuildContext context) {
  return AuthenticateModelInjector(child: SignUpDialog());
}

extension _name on String {
  bool isAtlest3CharactersLong() => this.length > 2;
}
