# Introdução a TDD (Test Driven Development)

TDD teve ampla utilização com métodos ágeis de desenvolvimento sendo definido principalmente por Kent Beck no livro *Test-Driven Development by Example*. Neste ele descreve duas regras básicas:
- Write new code only if an automated test has failed
- Eliminate duplication

Veremos como utilizar TDD com Python e uma parte extra em C++.

## TDD em Python

### unittest
O `unittest` é um framework de testes do Python que suporta testes
unitários (*test case*) e uma coleção de testes (*test suite*) de forma
automatizada.

Um exemplo simples de teste de função:
```python
#!/usr/bin/env python
import unittest

def fun(x):
    return x + 1

class MyTest(unittest.TestCase):
    def test(self):
        self.assertEqual(fun(3), 4)


if __name__ == '__main__':
    unittest.main()
```

Cada função dentro da classe  é um caso de teste idependente. Outros
testes são possíveis como:
- `assertTrue()`
- `assertFalse()`
- `assertRaises()` que esta se uma excessão específica acontece

Também é possível definir instruções de inicialização e finalização
caso necessário com `setUp()` e `tearDown()`.

Pode-se esperar que um teste falhe por meio de anotações:
```python
#!/usr/bin/env python
import unittest

def fun(x):
    return x + 1

class MyTest(unittest.TestCase):
    def test1(self):
        self.assertEqual(fun(3), 4)
    
    @unittest.expectedFailure
    def test2(self):
        self.assertEqual(fun(5), 7)

if __name__ == '__main__':
    unittest.main()
```


### Selenium

Selenium é um framework portável para testar aplicações Web. 
Pode ser tanto usado pela IDE, API, e WebDriver.

Iremos testar o Selenium com Python, primeiro crie um ambiente virtual
e depois instale o pacote:
```
virtualenv -p python3 selenium
cd selenium
source bin/activate
pip install selenium
```

Baixe o WebDriver para o Firefox [geckodriver](https://github.com/mozilla/geckodriver/) no link abaixo:
```
wget https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz
tar -xvzf geckodriver-v0.24.0-linux64.tar.gz
mv geckodriver bin
```

O último comando faz com o que o programa `geckodriver` fique disponível
no `PATH` do ambiente virtual.

Um exemplo simples com Selenium é abrir o Firefox e uma URL e esperar
10 segundos antes de fechar:
```python
#!/usr/bin/env python

from selenium import webdriver
import time

browser = webdriver.Firefox()
browser.get('http://www.ufsm.br/')

time.sleep(10)
browser.quit()
```

Pode-se utilizar o `unittest` com Selenium como no exemplo abaixo:
```python
#!/usr/bin/env python

from selenium import webdriver
import unittest

class VisitorTestUFSM(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def tearDown(self):
        self.browser.quit()

    def teste_ufsm(self):
        self.browser.get('http://www.ufsm.br/')
        self.assertIn('UFSM', self.browser.title)


    def teste_bife(self):
        self.browser.get('https://www.ufsm.br/orgaos-suplementares/ru/cardapio/')
        self.assertIn('Restaurante', self.browser.title)
        self.assertIn('Bife', self.browser.page_source)

if __name__ == '__main__':
    unittest.main(warnings='ignore')
```

## TDD em C++

O framework  C++ [Catch2](https://github.com/catchorg/Catch2/tree/v2.x) consegue ser utilizado apenas com o arquivo header [catch.hpp](catch.hpp) sem necessidade de instalação.

O programa de teste pode ser escrito apenas com testes sem a função `main` como no exemplo abaixo:
```C++
#define CATCH_CONFIG_MAIN // O Catch fornece uma main()
#include "catch.hpp"

TEST_CASE("Teste vazio") {
    std::list<int> entrada {1};
    REQUIRE(entrada.front() == 1);
}
```


## Links
- https://www.obeythetestinggoat.com/
- https://github.com/catchorg/Catch2
- https://docs.python.org/3/library/unittest.html
- https://selenium-python.readthedocs.io/getting-started.html
