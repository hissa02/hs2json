# hs2json — Biblioteca JSON em Haskell

## 1. Sobre o projeto

O **hs2json** é uma biblioteca desenvolvida em Haskell para representar valores JSON e convertê-los em texto formatado (*Pretty Printing*).

O projeto foi desenvolvido como atividade avaliativa da Unidade 2 da disciplina **Tópicos em Engenharia da Computação II — Programação Funcional**, da Universidade Federal do Maranhão (UFMA).

A implementação utiliza tipos algébricos de dados, casamento de padrões, recursão, composição de funções e testes baseados em propriedades com QuickCheck.

## 2. Integrantes

- **Hissa Bárbara Oliveira**
- **Yuram Almeida**

## 3. Funcionalidades

O projeto oferece:

- Representação dos tipos JSON: string, número, booleano, nulo, objeto e array.
- Funções de acesso (*accessors*) aos valores JSON.
- Formatação de objetos e arrays com indentação.
- Tratamento de caracteres especiais em strings JSON.
- Geração de valores aleatórios para testes.
- Testes automatizados com QuickCheck.
- Executável de demonstração.

## 4. Estrutura do projeto

```text
hs2json/
├── app/
│   └── Main.hs
├── src/
│   ├── SimpleJSON.hs
│   ├── Prettify.hs
│   └── PrettyJSON.hs
├── test/
│   └── Spec.hs
├── .gitignore
├── hs2json.cabal
└── README.md
```

### Descrição dos módulos

**SimpleJSON.hs:** define o tipo `JValue` e as funções `getString`, `getInt`, `getDouble`, `getBool`, `getObject`, `getArray` e `isNull`.

**Prettify.hs:** implementa a estrutura abstrata `Doc` e as funções utilizadas na composição e renderização de documentos formatados.

**PrettyJSON.hs:** converte valores `JValue` em representações textuais JSON, utilizando o módulo `Prettify`.

**Spec.hs:** contém o gerador `Arbitrary JValue` e as propriedades automatizadas com QuickCheck.

**Main.hs:** contém um exemplo de uso da biblioteca para demonstrar a formatação JSON.

## 5. Requisitos

Para compilar e executar o projeto, é necessário ter instalados:

- GHC (Glasgow Haskell Compiler)
- Cabal
- QuickCheck (dependência gerenciada pelo Cabal)

O desenvolvimento foi realizado utilizando GHC 9.10.3 e Cabal 3.16.1.0.

## 6. Instalação e execução

Clone o repositório:

```bash
git clone https://github.com/hissa02/hs2json.git
```

Acesse a pasta do projeto:

```bash
cd hs2json
```

Atualize o índice de pacotes, se necessário:

```bash
cabal update
```

Compile o projeto:

```bash
cabal build
```

Execute os testes:

```bash
cabal test --test-show-details=direct
```

Execute a demonstração:

```bash
cabal run hs2json-demo
```

## 7. Exemplo de funcionamento

O executável utiliza o seguinte valor JSON:

```haskell
JObject
    [ ("nome", JString "Hissa")
    , ("idade", JNumber 24)
    , ("ativo", JBool True)
    , ("notas", JArray [JNumber 8, JNumber 9])
    ]
```

A execução produz:

```json
{
  "nome":"Hissa",
  "idade":24,
  "ativo":true,
  "notas":[
    8,
    9
  ]
}
```

## 8. Testes automatizados

Os testes são realizados com a biblioteca QuickCheck, que gera automaticamente diferentes entradas para verificar propriedades do programa.

O projeto implementa cinco propriedades:

| Propriedade | Objetivo |
|---|---|
| `prop_getString` | Verificar a recuperação de strings |
| `prop_getBool` | Verificar a recuperação de booleanos |
| `prop_getDouble` | Verificar a recuperação de números |
| `prop_getArray` | Verificar a recuperação de arrays |
| `prop_isNull` | Verificar a identificação de valores nulos |

O gerador `Arbitrary JValue` utiliza `sized` e `resize` para controlar a complexidade de estruturas recursivas.

Na execução realizada durante o desenvolvimento, todas as cinco propriedades passaram com 100 testes cada.

## 9. Vídeo de apresentação

- [https://drive.google.com/drive/folders/1VUwzCH2i3JtUK0mkZuV9-jN8WGSsH3xY?usp=sharing]

A apresentação demonstra a estrutura do projeto, as principais funcionalidades, a execução dos testes e o funcionamento do Pretty Printer.

**Link do vídeo:** 

## 10. Referências

- [Tutorial de Haskell — LambdaGeo](https://lambdageo-edu.github.io/lambdageo-tutorials/haskell/)
- [QuickCheck — Hackage](https://hackage.haskell.org/package/QuickCheck)
- [Cabal — Documentação oficial](https://cabal.readthedocs.io/)

## 11. Repositório

Código-fonte e histórico de desenvolvimento disponíveis 

- [https://github.com/hissa02/hs2json.git]
