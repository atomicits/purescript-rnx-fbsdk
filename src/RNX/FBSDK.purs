module RNX.FBSDK where

import Prelude
import Control.Monad.Aff (Aff, attempt, makeAff)
import Control.Monad.Aff.Console (CONSOLE)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Data.Either (Either)
import React (ReactClass, ReactElement, createElement)
import React.DOM.Props (unsafeMkProps, unsafeFromPropsArray, Props)

foreign import _getAccessToken :: forall e scallback ecallback. Array String
                               -> scallback
                               -> ecallback
                               -> Eff e Unit

foreign import _getUserDetails :: forall e scallback ecallback. String
                               -> String
                               -> scallback
                               -> ecallback
                               -> Eff e Unit

foreign import _graphRequest :: forall e scallback ecallback. String
                               -> String
                               -> String
                               -> scallback
                               -> ecallback
                               -> Eff e Unit

foreign import loginButtonClass :: forall props. ReactClass props

type LoginResult = { isCancelled :: Boolean
                   , grantedPermissions :: Array String
                   , declinedPermissions :: Array String
                   }

_getAccessToken' :: forall e res. Array String -> Aff e res
_getAccessToken' permissions  = makeAff (\error success -> _getAccessToken permissions success error)


getAccessToken :: forall e res. Array String -> Aff (console :: CONSOLE | e) (Either Error res)
getAccessToken permissions = attempt $ _getAccessToken' permissions



_getUserDetails' :: forall e res. String -> String -> Aff e  res
_getUserDetails' token accessParams =
  makeAff (\error success -> _getUserDetails token accessParams success error)


getUserDetails :: forall e res. String
               -> String
               -> Aff (console :: CONSOLE | e) (Either Error res)
getUserDetails token accessParams = attempt $ _getUserDetails' token accessParams


_graphRequest' :: forall e res. String -> String -> String -> Aff e  res
_graphRequest' token path accessParams =
  makeAff (\error success -> _graphRequest token path accessParams success error)


graphRequest :: forall e res. String
               -> String
               -> String
               -> Aff (console :: CONSOLE | e) (Either Error res)
graphRequest token path accessParams = attempt $ _graphRequest' token path accessParams



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
