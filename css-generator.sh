#! /usr/bin/env perl -w
use strict;
use 5.024;
# задаем кодировку
use utf8;
use open qw(:std :utf8);

# подключаем модуль, который надо сначала установить
use Mojo::DOM;

# переопределяем переменную, чтоб файл считывался целиком, а не построчно
local $/ = undef;

# создаем объект из входного файла переданного в командной строке
my $dom = Mojo::DOM->new(<>);

# задаем файловые дескрипторы для вывода
open (CSS, ">>:utf8","new_style.css") or die "Error opening file new_style.css";
open (HTML, ">>:utf8", "new_index.html") or die "Error opening file new_index.html";

# пробегаемся циклом по элементам style
my $i = 0;
for my $e ($dom->find('style')->each) {
    # выводим в файл содержимое элемента и ушатываем его
    print CSS $e->text;
    $e = '';
}

# начинаем бегать по элементам с заданным аттрибутом style
for my $e ($dom->find('[style]')->each) {
    # добавляем уникальный класс каждому элементу
    $e->{class} .= $e->{class} ? " custom_class_$i" : "custom_class_$i";
    # выводим стили в файл и удаляем аттрибут
    print CSS ".custom_class_$i {$e->{style}}";
    delete $e->attr->{style};
    $i++;
}

# сохраняем оставшийся html
print HTML $dom;
