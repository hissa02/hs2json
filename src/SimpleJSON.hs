
module SimpleJSON where

-- Representa os diferentes tipos de valores JSON
data JValue
    = JString String
    | JNumber Double
    | JBool Bool
    | JNull
    | JObject [(String, JValue)]
    | JArray [JValue]
    deriving (Eq, Ord, Show)

-- Extrai uma String de um valor JSON
getString :: JValue -> Maybe String
getString (JString s) = Just s
getString _ = Nothing

-- Extrai um Bool de um valor JSON
getBool :: JValue -> Maybe Bool
getBool (JBool b) = Just b
getBool _ = Nothing

-- Extrai um numero inteiro de um valor JSON
getInt :: JValue -> Maybe Int
getInt (JNumber n)
    | isInfinite n || isNaN n = Nothing
    | n == fromIntegral (truncate n :: Integer)
      && n >= fromIntegral (minBound :: Int)
      && n < fromIntegral (maxBound :: Int) + 1
        = Just (truncate n)
    | otherwise = Nothing
getInt _ = Nothing

-- Extrai um numero decimal de um valor JSON
getDouble :: JValue -> Maybe Double
getDouble (JNumber n) = Just n
getDouble _ = Nothing

-- Extrai os pares chave-valor de um objeto JSON
getObject :: JValue -> Maybe [(String, JValue)]
getObject (JObject obj) = Just obj
getObject _ = Nothing

-- Extrai os elementos de um array JSON
getArray :: JValue -> Maybe [JValue]
getArray (JArray arr) = Just arr
getArray _ = Nothing

-- Verifica se o valor JSON e nulo
isNull :: JValue -> Bool
isNull JNull = True
isNull _ = False
