module Main where

import SimpleJSON
import PrettyJSON (renderJValue)

main :: IO ()
main = do
    putStrLn "=== Demonstracao hs2json ==="

    let exemplo = JObject
            [ ("nome", JString "Hissa")
            , ("idade", JNumber 24)
            , ("ativo", JBool True)
            , ("notas", JArray [JNumber 8, JNumber 9])
            ]

    putStrLn (renderJValue exemplo)
