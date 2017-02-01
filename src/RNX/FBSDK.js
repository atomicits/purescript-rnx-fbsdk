'use strict';


var FBSDK = require('react-native-fbsdk');

exports._getAccessToken = function(callback) {
    return function(){
        console.log("hi");
        FBSDK.LoginManager.logInWithReadPermissions(['public_profile']).then(
            //console.log("inside the promise");
            function(result) {
                console.log("insode result function");
                if (result.isCancelled) {
                    console.log('Facebook Login cancelled');
                } else {
                    console.log("not cancelled");
                    FBSDK.AccessToken.getCurrentAccessToken().then(
                        function(accessToken) {
                            console.log(accessToken);
                            callback(accessToken)();
                        }
                    );
                }
            },
            function(error) {
                console.warn('Login fail with error: ' + error);
            }
        );
    };
};



exports._getUserDetails = function(token){
    return function(requestParams) {
        return function(callback) {
            return function(){
                var responseCallback = function(error, result) {
                    if(error){
                        console.log(error);
                    }else{
                        console.log(result);
                        var data = {
                            uid: result.id,
                            email: result.email,
                            date_of_birth: result.birthday,
                            name: result.name,
                            location: result.hometown.name,
                            gender: result.gender
                        };
                        callback(data)();
                    }
                };

                var profileRequestParams = {
                    fields : {
                        string : requestParams
                    }
                };

                var profileRequestConfig = {
                    httpMethod: 'GET',
                    version: 'v2.6',
                    parameters: profileRequestParams,
                    accessToken: token
                };

                var profileRequest = new FBSDK.GraphRequest('/me', profileRequestConfig, responseCallback);
                return new FBSDK.GraphRequestManager().addRequest(profileRequest).start();
            };
        };
    };
};

exports.loginButtonClass = FBSDK.LoginButton;
