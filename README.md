# script StatisticCreator

## Общее
 Скрипт создает или обновляет информацию в таблицах статистики ПРОЕКТА на основе массива входящих данных.

## Подготовка к запуску
 Создать в дирректории config файл с конфигурацией для запуска (см. пример локального хоста: /config/local.yml)
 Создать партиции (если необходимо):
  1. Настроить ssh подключение к скриптовой машине ПРОЕКТА
  2. Написать соответствующий скрипт (см. пример scripts/bz3_addpart.sh) - или выполнить его контент в консоли rails приложения. Пример запуска:
   ```
   export date='2017-03-19'
   sh scripts/bz3_addpart.sh
   ```
  3. Установить гем activerecord : `gem install activerecord -v 4.2.6`
  4. Устанить гем pg ~> 0.21 : `gem install pg -v 0.21.0`

## Запуск
 ```
 ruby all.rb 123 local
 ```
 , где 123 - id компании, для которой создается статистика;
 local - название конфигурационного файла (/config/local.yml)

 Дополнительно может быть передана дата, если требуется создать статистику не с сегодняшнего дня, например:
 ```
 ruby all.rb 123 local 2016-12-05
 ```
## Типичные проблемы
 ```
 Inserted data is out of range. Fix statistics.company_statistic_pages_by_months_insert_trigger. (ActiveRecord::StatementInvalid)
 ```
 Нужно добавить партиции: см. Подготовка к запуску - Создать партиции
