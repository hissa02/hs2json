module PrettyJSON
    ( renderJValue
    ) where

import Prelude hiding ((<>))
import SimpleJSON (JValue(..))
import Prettify

-- | Converte um JValue em uma String JSON formatada.
renderJValue :: JValue -> String
renderJValue = render . pretty

-- Converte JValue em Doc.
pretty :: JValue -> Doc
pretty (JString s)  = string s
pretty (JNumber n)  = double n
pretty (JBool True) = text "true"
pretty (JBool False)= text "false"
pretty JNull        = text "null"
pretty (JArray xs)  = series '[' ']' pretty xs
pretty (JObject kv) = series '{' '}' (field) kv

-- Formata um par chave-valor de objeto.
field :: (String, JValue) -> Doc
field (k, v) = string k <> char ':' <> pretty v

-- Formata uma série de valores (array ou objeto) com colchetes/chaves.
series :: Char -> Char -> (a -> Doc) -> [a] -> Doc
series open close f xs =
    char open <>
    (if null xs
        then empty
        else indent 2 (line <> separar (map f xs)) <> line) <>
    char close

-- Adiciona virgulas entre os elementos
separar :: [Doc] -> Doc
separar [] = empty
separar [x] = x
separar (x:xs) = x <> char ',' <> line <> separar xs

-- Escapa e formata uma string JSON.
string :: String -> Doc
string s = char '"' <> hcat (map escapeChar s) <> char '"'
  where
    escapeChar '"'  = text "\\\""
    escapeChar '\\' = text "\\\\"
    escapeChar '\n' = text "\\n"
    escapeChar '\t' = text "\\t"
    escapeChar '\r' = text "\\r"
    escapeChar '\b' = text "\\b"
    escapeChar '\f' = text "\\f"
    escapeChar c
        | c < ' '   = text ("\\u" ++ hex4 (fromEnum c))
        | otherwise = char c

    hex4 :: Int -> String
    hex4 n =
        let digits = "0123456789abcdef"
            digit :: Int -> Char
            digit i = digits !! ((n `div` (16 ^ i)) `mod` 16)
        in map digit [3, 2, 1, 0]

-- Formata um número (Double), evitando notação científica quando possível.
double :: Double -> Doc
double n
    | isInteger n = text (show (round n :: Integer))
    | otherwise   = text (show n)
  where
    isInteger x = fromIntegral (round x :: Integer) == x

-- Concatena uma lista de documentos sem separador.
hcat :: [Doc] -> Doc
hcat = foldr (<>) empty