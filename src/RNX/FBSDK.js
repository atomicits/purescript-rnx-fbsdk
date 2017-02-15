'use strict';


var FBSDK = require('react-native-fbsdk');

exports._getAccessToken = function(permissionList){
    return function(success_callback){
        return function(error_callback) {
            return function(){
                FBSDK.LoginManager.logInWithReadPermissions(permissionList).then(
                    function(result) {
                        if (result.isCancelled) {
                            error_callback({name: "User Cancelled", message : "user callcelled the request"})();
                        } else {
                            FBSDK.AccessToken.getCurrentAccessToken().then(
                                function(accessToken) {
                                    success_callback(accessToken)();
                                },function(error){
                                    error_callback(error)();
                                }
                            );
                        }
                    },
                    function(error) {
                        error_callback(error)();
                    }
                );
            };
        };
    };
};





exports._getUserDetails = function(token){
    return function(requestParams) {
        return function(success_callback) {
            return function(error_callback){
                return function(){
                    var responseCallback = function(error, result) {
                        if(error){
                            error_callback(error)();
                        }else{
                            var data = {
                                uid: result.id,
                                email: result.email,
                                date_of_birth: result.birthday,
                                name: result.name,
                                location: result.hometown ? result.hometown.name : "",
                                gender: result.gender
                            };
                            success_callback(data)();
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
};

exports.loginButtonClass = FBSDK.LoginButton;


exports._graphRequest = function(token){
    return function(path){
        return function(params){
            return function(success_callback){
                return function(error_callback){
                    return function(){
                        var responseCallback = function(error, result) {
                            if(error){
                                error_callback(error)();
                            }else{
                                success_callback(result)();
                            }
                        };
                        var requestParams = {
                            fields : {
                                string : params
                            }
                        };

                        var requestConfig = {
                            httpMethod: 'GET',
                            version: 'v2.6',
                            parameters: requestParams,
                            accessToken: token
                        };
                        var request = new FBSDK.GraphRequest(path, requestConfig, responseCallback);
                        return new FBSDK.GraphRequestManager().addRequest(request).start();
                    };
                };
            };
        };
    };
};
