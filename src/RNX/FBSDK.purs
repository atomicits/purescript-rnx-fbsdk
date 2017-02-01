module RNX.FBSDK where


import Prelude
import Control.Monad.Aff (Aff, attempt, makeAff)
import Control.Monad.Aff.Console (CONSOLE)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Data.Either (Either)
import React (ReactClass, ReactElement, createElement)
import React.DOM.Props (unsafeMkProps, unsafeFromPropsArray, Props)


foreign import _getAccessToken :: forall e scallback ecallback. scallback
                               -> ecallback
                               -> Eff e Unit

foreign import _getUserDetails :: forall e scallback ecallback. String
                               -> String
                               -> scallback
                               -> ecallback
                               -> Eff e Unit

foreign import loginButtonClass :: forall props. ReactClass props

type LoginResult = { isCancelled :: Boolean
                   , grantedPermissions :: Array String
                   , declinedPermissions :: Array String
                   }

_getAccessToken' :: forall e res. Aff e res
_getAccessToken' = makeAff (\error success -> _getAccessToken success error)


getAccessToken :: forall e res. Aff (console :: CONSOLE | e) (Either Error res)
getAccessToken = attempt $ _getAccessToken'



_getUserDetails' :: forall e res. String -> String -> Aff e  res
_getUserDetails' token accessParams =
  makeAff (\error success -> _getUserDetails token accessParams success error)


getUserDetails :: forall e res. String
               -> String
               -> Aff (console :: CONSOLE | e) (Either Error res)
getUserDetails token accessParams = attempt $ _getUserDetails' token accessParams



fbLoginButton :: Array Props -> ReactElement
fbLoginButton props = createElement loginButtonClass (unsafeFromPropsArray props) []


readPermissions :: Array String -> Props
readPermissions = unsafeMkProps "readPermissions"


publishPermissions :: Array String -> Props
publishPermissions = unsafeMkProps "publishPermissions"


onLoginFinished :: forall error . (error -> LoginResult -> Unit) -> Props
onLoginFinished = unsafeMkProps "onLoginFinished"


onLogoutFinished :: (Unit -> Unit) -> Props
onLogoutFinished = unsafeMkProps "onLogoutFinished"


loginBehaviorAndroid :: String -> Props
loginBehaviorAndroid = unsafeMkProps "loginBehaviorAndroid"


loginBehaviorIOS :: String -> Props
loginBehaviorIOS = unsafeMkProps "loginBehaviorIOS"


defaultAudience :: String -> Props
defaultAudience = unsafeMkProps "defaultAudience"


tooltipBehaviorIOS :: String -> Props
tooltipBehaviorIOS = unsafeMkProps "tooltipBehaviorIOS"
