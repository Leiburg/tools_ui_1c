#Область ПрограммныйИнтерфейс

// Параметры старта сеанса.
// 
// Возвращаемое значение:
//  Структура - Параметры старта сеанса:
// * ДобавленыПраваНаРасширение - Булево -
// * НомерСеанса - Число -
// * ЯзыкСинтаксисаКонфигурации - Строка -
Функция ПараметрыСтартаСеанса() Экспорт

	ПараметрыСтартаСеанса=Новый Структура;

	Если Не УИ_ОбщегоНазначенияКлиентСервер.ЭтоПортативнаяПоставка() Тогда
		//@skip-check using-isinrole
		Если ПравоДоступа("Администрирование", Метаданные) И Не РольДоступна("УИ_ПолныеПрава")
			И ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0 Тогда

			ВерсияБСП = УИ_ОбщегоНазначения.ВерсияБСП();
			Если УИ_ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияБСП, "3.1.6.0") >= 0 Тогда
			//РегистрыСведений.ПараметрыРаботыВерсийРасширений.ЗаполнитьВсеПараметрыРаботыПоследнейВерсииРасширений();
				РезультатПримененияПрав =  УИ_ОбщегоНазначения.РезультатУстановкиПравДоступаДляБСП_3_1_6_ИВыше();
			Иначе
				ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
				ТекущийПользователь.Роли.Добавить(Метаданные.Роли.УИ_ПолныеПрава);
				ТекущийПользователь.Записать();
				
				РезультатПримененияПрав= Истина;
			КонецЕсли;

			ПараметрыСтартаСеанса.Вставить("ДобавленыПраваНаРасширение", РезультатПримененияПрав);
		Иначе
			ПараметрыСтартаСеанса.Вставить("ДобавленыПраваНаРасширение", Ложь);
		КонецЕсли;
	Иначе
		ПараметрыСтартаСеанса.Вставить("ДобавленыПраваНаРасширение", Ложь);	
	КонецЕсли;

	ПараметрыСтартаСеанса.Вставить("НомерСеанса", НомерСеансаИнформационнойБазы());
	ПараметрыСтартаСеанса.Вставить("ЯзыкСинтаксисаКонфигурации", УИ_РедакторКодаСервер.ЯзыкСинтаксисаКонфигурации());

	Возврат ПараметрыСтартаСеанса;
КонецФункции

// Устанавливает жирное оформление шрифта заголовков групп формы для их корректного отображения в интерфейсе 8.2.
// В интерфейсе Такси заголовки групп с обычным выделением и без выделения выводится большим шрифтом.
// В интерфейсе 8.2 такие заголовки выводятся как обычные надписи и не ассоциируются с заголовками.
// Эта функция предназначена для визуального выделения (жирным шрифтом) заголовков групп в режиме интерфейса 8.2.
//
// Параметры:
//  Форма - УправляемаяФорма - форма для изменения шрифта заголовков групп;
//  ИменаГрупп - Строка - список имен групп формы, разделенных запятыми. Если имена групп не указаны,
//                        то оформление будет применено ко всем группам на форме.
//
// Пример:
//  Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//    СтандартныеПодсистемыСервер.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект);
//
Процедура УстановитьОтображениеЗаголовковГрупп(Форма, ИменаГрупп = "") Экспорт

	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		ЖирныйШрифт = Новый Шрифт(, , Истина);
		Если Не ЗначениеЗаполнено(ИменаГрупп) Тогда
			Для Каждого Элемент Из Форма.Элементы Цикл
				Если Тип(Элемент) = Тип("ГруппаФормы") И Элемент.Вид = ВидГруппыФормы.ОбычнаяГруппа
					И Элемент.ОтображатьЗаголовок = Истина И (Элемент.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение
					Или Элемент.Отображение = ОтображениеОбычнойГруппы.Нет) Тогда
					Элемент.ШрифтЗаголовка = ЖирныйШрифт;
				КонецЕсли;
			КонецЦикла;
		Иначе
			МассивЗаголовков = УИ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаГрупп, , , Истина);
			Для Каждого ИмяЗаголовка Из МассивЗаголовков Цикл
				Элемент = Форма.Элементы[ИмяЗаголовка];
				Если Элемент.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение Или Элемент.Отображение
					= ОтображениеОбычнойГруппы.Нет Тогда
					Элемент.ШрифтЗаголовка = ЖирныйШрифт;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Код основного языка.
// 
// Возвращаемое значение:
//  Строка - Код основного языка
Функция КодОсновногоЯзыка() Экспорт
	Возврат УИ_ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка();
КонецФункции

// См. СтандартныеПодсистемыПовтИсп.СсылкиПоИменамПредопределенных
Функция СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных) Экспорт

	Возврат УИ_ОбщегоНазначенияПовтИсп.СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных);

КонецФункции

Функция ЗначенияРеквизитовОбъекта(Ссылка, Знач Реквизиты, ВыбратьРазрешенные = Ложь) Экспорт

	Возврат УИ_ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты, ВыбратьРазрешенные);

КонецФункции

// Значение реквизита, прочитанного из информационной базы по ссылке на объект.
//
// Если необходимо зачитать реквизит независимо от прав текущего пользователя,
// то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  Ссылка    - ЛюбаяСсылка - объект, значения реквизитов которого необходимо получить.
//            - Строка      - полное имя предопределенного элемента, значения реквизитов которого необходимо получить.
//  ИмяРеквизита       - Строка - имя получаемого реквизита.
//  ВыбратьРазрешенные - Булево - если Истина, то запрос к объекту выполняется с учетом прав пользователя, и в случае,
//                                    - если есть ограничение на уровне записей, то возвращается Неопределено;
//                                    - если нет прав для работы с таблицей, то возникнет исключение.
//                              - если Ложь, то возникнет исключение при отсутствии прав на таблицу
//                                или любой из реквизитов.
//
// Возвращаемое значение:
//  Произвольный - зависит от типа значения прочитанного реквизита.
//               - если в параметр Ссылка передана пустая ссылка, то возвращается Неопределено.
//               - если в параметр Ссылка передана ссылка несуществующего объекта (битая ссылка), 
//                 то возвращается Неопределено.
//
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные = Ложь) Экспорт

	Возврат УИ_ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные);

КонецФункции

Функция ДанныеСохраненногоПароляПользователяИБ(ИмяПользователя) Экспорт
	Возврат УИ_Пользователи.ДанныеСохраненногоПароляПользователяИБ(ИмяПользователя);
КонецФункции

Процедура УстановитьПарольПользователюИБ(ИмяПользователя, Пароль) Экспорт
	УИ_Пользователи.УстановитьПарольПользователюИБ(ИмяПользователя, Пароль);
КонецПроцедуры

Процедура ВосстановитьДанныеПользователяПослеЗапускаСеансаПодПользователем(ИмяПользователя,
	ДанныеСохраненногоПароляПользователяИБ) Экспорт
	УИ_Пользователи.ВосстановитьДанныеПользователяПослеЗапускаСеансаПодПользователем(ИмяПользователя,
		ДанныеСохраненногоПароляПользователяИБ);
КонецПроцедуры

Процедура ДобавитьМассивОбъектовКСравнению(Объекты) Экспорт
	УИ_ОбщегоНазначения.ДобавитьМассивОбъектовКСравнению(Объекты);
КонецПроцедуры

Процедура ВыгрузитьОбъектыВXMLНаСервере(МассивОбъектов, АдресФайлаВоВременномХранилище, ИдентфикаторФормы=Неопределено) Экспорт
	ОбработкаВыгрузки= Обработки.УИ_ВыгрузкаЗагрузкаДанныхXMLСФильтрами.Создать();
	ОбработкаВыгрузки.Инициализация();
	ОбработкаВыгрузки.ВыгружатьСДокументомЕгоДвижения=Истина;
	ОбработкаВыгрузки.ИспользоватьФорматFastInfoSet=Ложь;
	
	Для Каждого ТекОбъект Из МассивОбъектов Цикл
		НС=ОбработкаВыгрузки.ДополнительныеОбъектыДляВыгрузки.Добавить();
		НС.Объект=ТекОбъект;
		НС.ИмяОбъектаДляЗапроса=УИ_ОбщегоНазначения.ИмяТаблицыПоСсылке(ТекОбъект);
	КонецЦикла;
		
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(".xml");
	
	ОбработкаВыгрузки.ВыполнитьВыгрузку(ИмяВременногоФайла, , Новый ТаблицаЗначений);
		
	Файл = Новый Файл(ИмяВременногоФайла);

	Если Файл.Существует() Тогда

		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
		АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ИдентфикаторФормы);
		УдалитьФайлы(ИмяВременногоФайла);

	КонецЕсли;
	
КонецПроцедуры

// Преобразует (сериализует) любое значение в XML-строку.
// Преобразованы в могут быть только те объекты, для которых в синтакс-помощнике указано, что они сериализуются.
// См. также ЗначениеИзСтрокиXML.
//
// Параметры:
//  Значение - Произвольный - значение, которое необходимо сериализовать в XML-строку.
//
// Возвращаемое значение:
//  Строка - XML-строка.
//
Функция ЗначениеВСтрокуXML(Значение) Экспорт

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Значение, НазначениеТипаXML.Явное);

	Возврат ЗаписьXML.Закрыть();
КонецФункции

// Выполняет преобразование (десериализацию) XML-строки в значение.
// См. также ЗначениеВСтрокуXML.
//
// Параметры:
//  СтрокаXML - Строка - XML-строка, с сериализованным объектом..
//
// Возвращаемое значение:
//  Произвольный - значение, полученное из переданной XML-строки.
//
Функция ЗначениеИзСтрокиXML(СтрокаXML, Тип = Неопределено) Экспорт

	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);

	Если Тип = Неопределено Тогда
		Возврат СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
	Иначе
		Возврат СериализаторXDTO.ПрочитатьXML(ЧтениеXML, Тип);
	КонецЕсли;
КонецФункции

Функция АдресОписанияМетаданныхКонфигурации() Экспорт
	Возврат УИ_ОбщегоНазначения.АдресОписанияМетаданныхКонфигурации();
КонецФункции

#Область JSON

Функция мПрочитатьJSON(Значение) Экспорт
	Возврат УИ_ОбщегоНазначенияКлиентСервер.мПрочитатьJSON(Значение);
КонецФункции // ПрочитатьJSON()

Функция мЗаписатьJSON(СтруктураДанных) Экспорт
	Возврат УИ_ОбщегоНазначенияКлиентСервер.мЗаписатьJSON(СтруктураДанных);

КонецФункции // ЗаписатьJSON(
#КонецОбласти



#Область ХранилищеНастроек

////////////////////////////////////////////////////////////////////////////////
// Сохранение, чтение и удаление настроек из хранилищ.

// Сохраняет настройку в хранилище общих настроек, как метод платформы Сохранить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, сохранение пропускается без ошибки.
//
// Параметры:
//   КлючОбъекта       - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек      - Строка           - см. синтакс-помощник платформы.
//   Настройки         - Произвольный     - см. синтакс-помощник платформы.
//   ОписаниеНастроек  - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя   - Строка           - см. синтакс-помощник платформы.
//   ОбновитьПовторноИспользуемыеЗначения - Булево - выполнить одноименный метод платформы.
//
Процедура ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек = Неопределено,
	ИмяПользователя = Неопределено, ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт

	УИ_ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек,
		ИмяПользователя, ОбновитьПовторноИспользуемыеЗначения);

КонецПроцедуры

// Сохраняет несколько настроек в хранилище общих настроек, как метод платформы Сохранить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, сохранение пропускается без ошибки.
// 
// Параметры:
//   НесколькоНастроек - Массив - со значениями:
//     * Значение - Структура - со свойствами:
//         * Объект    - Строка       - см. параметр КлючОбъекта  в синтакс-помощнике платформы.
//         * Настройка - Строка       - см. параметр КлючНастроек в синтакс-помощнике платформы.
//         * Значение  - Произвольный - см. параметр Настройки    в синтакс-помощнике платформы.
//
//   ОбновитьПовторноИспользуемыеЗначения - Булево - выполнить одноименный метод платформы.
//
Процедура ХранилищеОбщихНастроекСохранитьМассив(НесколькоНастроек, ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	УИ_ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(НесколькоНастроек, ОбновитьПовторноИспользуемыеЗначения);

КонецПроцедуры

// Загружает настройку из хранилища общих настроек, как метод платформы Загрузить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Кроме того, возвращает указанное значение по умолчанию, если настройки не найдены.
// Если нет права СохранениеДанныхПользователя, возвращается значение по умолчанию без ошибки.
//
// В возвращаемом значении очищаются ссылки на несуществующий объект в базе данных, а именно
// - возвращаемая ссылка заменяется на указанное значение по умолчанию;
// - из данных типа Массив ссылки удаляются;
// - у данных типа Структура и Соответствие ключ не меняется, а значение устанавливается Неопределено;
// - анализ значений в данных типа Массив, Структура, Соответствие выполняется рекурсивно.
//
// Параметры:
//   КлючОбъекта          - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек         - Строка           - см. синтакс-помощник платформы.
//   ЗначениеПоУмолчанию  - Произвольный     - значение, которое возвращается, если настройки не найдены.
//                                             Если не указано, возвращается значение Неопределено.
//   ОписаниеНастроек     - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя      - Строка           - см. синтакс-помощник платформы.
//
// Возвращаемое значение: 
//   Произвольный - см. синтакс-помощник платформы.
//
Функция ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено,
	ОписаниеНастроек = Неопределено, ИмяПользователя = Неопределено) Экспорт
	Возврат УИ_ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию,
		ОписаниеНастроек, ИмяПользователя)

КонецФункции

// Удаляет настройку из хранилища общих настроек, как метод платформы Удалить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, удаление пропускается без ошибки.
//
// Параметры:
//   КлючОбъекта     - Строка, Неопределено - см. синтакс-помощник платформы.
//   КлючНастроек    - Строка, Неопределено - см. синтакс-помощник платформы.
//   ИмяПользователя - Строка, Неопределено - см. синтакс-помощник платформы.
//
Процедура ХранилищеОбщихНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя) Экспорт

	УИ_ОбщегоНазначения.ХранилищеОбщихНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя);

КонецПроцедуры

// Сохраняет настройку в хранилище системных настроек, как метод платформы Сохранить
// объекта СтандартноеХранилищеНастроекМенеджер, но с поддержкой длины ключа настроек
// более 128 символов путем хеширования части, которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, сохранение пропускается без ошибки.
//
// Параметры:
//   КлючОбъекта       - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек      - Строка           - см. синтакс-помощник платформы.
//   Настройки         - Произвольный     - см. синтакс-помощник платформы.
//   ОписаниеНастроек  - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя   - Строка           - см. синтакс-помощник платформы.
//   ОбновитьПовторноИспользуемыеЗначения - Булево - выполнить одноименный метод платформы.
//
Процедура ХранилищеСистемныхНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек = Неопределено,
	ИмяПользователя = Неопределено, ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт

	УИ_ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек,
		ИмяПользователя, ОбновитьПовторноИспользуемыеЗначения);

КонецПроцедуры

// Загружает настройку из хранилища системных настроек, как метод платформы Загрузить,
// объекта СтандартноеХранилищеНастроекМенеджер, но с поддержкой длины ключа настроек
// более 128 символов путем хеширования части, которая превышает 96 символов.
// Кроме того, возвращает указанное значение по умолчанию, если настройки не найдены.
// Если нет права СохранениеДанныхПользователя, возвращается значение по умолчанию без ошибки.
//
// В возвращаемом значении очищаются ссылки на несуществующий объект в базе данных, а именно:
// - возвращаемая ссылка заменяется на указанное значение по умолчанию;
// - из данных типа Массив ссылки удаляются;
// - у данных типа Структура и Соответствие ключ не меняется, а значение устанавливается Неопределено;
// - анализ значений в данных типа Массив, Структура, Соответствие выполняется рекурсивно.
//
// Параметры:
//   КлючОбъекта          - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек         - Строка           - см. синтакс-помощник платформы.
//   ЗначениеПоУмолчанию  - Произвольный     - значение, которое возвращается, если настройки не найдены.
//                                             Если не указано, возвращается значение Неопределено.
//   ОписаниеНастроек     - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя      - Строка           - см. синтакс-помощник платформы.
//
// Возвращаемое значение: 
//   Произвольный - см. синтакс-помощник платформы.
//
Функция ХранилищеСистемныхНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено,
	ОписаниеНастроек = Неопределено, ИмяПользователя = Неопределено) Экспорт

	Возврат УИ_ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию,
		ОписаниеНастроек, ИмяПользователя);

КонецФункции

// Удаляет настройку из хранилища системных настроек, как метод платформы Удалить,
// объекта СтандартноеХранилищеНастроекМенеджер, но с поддержкой длины ключа настроек
// более 128 символов путем хеширования части, которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, удаление пропускается без ошибки.
//
// Параметры:
//   КлючОбъекта     - Строка, Неопределено - см. синтакс-помощник платформы.
//   КлючНастроек    - Строка, Неопределено - см. синтакс-помощник платформы.
//   ИмяПользователя - Строка, Неопределено - см. синтакс-помощник платформы.
//
Процедура ХранилищеСистемныхНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя) Экспорт

	УИ_ОбщегоНазначения.ХранилищеСистемныхНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя);

КонецПроцедуры

// Сохраняет настройку в хранилище настроек данных форм, как метод платформы Сохранить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, сохранение пропускается без ошибки.
//
// Параметры:
//   КлючОбъекта       - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек      - Строка           - см. синтакс-помощник платформы.
//   Настройки         - Произвольный     - см. синтакс-помощник платформы.
//   ОписаниеНастроек  - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя   - Строка           - см. синтакс-помощник платформы.
//   ОбновитьПовторноИспользуемыеЗначения - Булево - выполнить одноименный метод платформы.
//
Процедура ХранилищеНастроекДанныхФормСохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек = Неопределено,
	ИмяПользователя = Неопределено, ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт

	УИ_ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек,
		ИмяПользователя, ОбновитьПовторноИспользуемыеЗначения);

КонецПроцедуры

// Загружает настройку из хранилища настроек данных форм, как метод платформы Загрузить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Кроме того, возвращает указанное значение по умолчанию, если настройки не найдены.
// Если нет права СохранениеДанныхПользователя, возвращается значение по умолчанию без ошибки.
//
// В возвращаемом значении очищаются ссылки на несуществующий объект в базе данных, а именно
// - возвращаемая ссылка заменяется на указанное значение по умолчанию;
// - из данных типа Массив ссылки удаляются;
// - у данных типа Структура и Соответствие ключ не меняется, а значение устанавливается Неопределено;
// - анализ значений в данных типа Массив, Структура, Соответствие выполняется рекурсивно.
//
// Параметры:
//   КлючОбъекта          - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек         - Строка           - см. синтакс-помощник платформы.
//   ЗначениеПоУмолчанию  - Произвольный     - значение, которое возвращается, если настройки не найдены.
//                                             Если не указано, возвращается значение Неопределено.
//   ОписаниеНастроек     - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя      - Строка           - см. синтакс-помощник платформы.
//
// Возвращаемое значение: 
//   Произвольный - см. синтакс-помощник платформы.
//
Функция ХранилищеНастроекДанныхФормЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено,
	ОписаниеНастроек = Неопределено, ИмяПользователя = Неопределено) Экспорт

	Возврат УИ_ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию,
		ОписаниеНастроек, ИмяПользователя);

КонецФункции

// Удаляет настройку из хранилища настроек данных форм, как метод платформы Удалить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, удаление пропускается без ошибки.
//
// Параметры:
//   КлючОбъекта     - Строка, Неопределено - см. синтакс-помощник платформы.
//   КлючНастроек    - Строка, Неопределено - см. синтакс-помощник платформы.
//   ИмяПользователя - Строка, Неопределено - см. синтакс-помощник платформы.
//
Процедура ХранилищеНастроекДанныхФормУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя) Экспорт

	УИ_ОбщегоНазначения.ХранилищеНастроекДанныхФормУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя);

КонецПроцедуры

#КонецОбласти

#Область Алгоритмы

Функция ПолучитьСсылкуСправочникАлгоритмы(Алгоритм) Экспорт
	Возврат УИ_ОбщегоНазначения.ПолучитьСсылкуСправочникАлгоритмы(Алгоритм);
КонецФункции

Функция ВыполнитьАлгоритм(АлгоритмСсылка, ВходящиеПараметры = Неопределено, ОшибкаВыполнения = Ложь,
	СообщениеОбОшибке = "") Экспорт
	Возврат УИ_ОбщегоНазначения.ВыполнитьАлгоритм(АлгоритмСсылка, ВходящиеПараметры, ОшибкаВыполнения,
		СообщениеОбОшибке);
КонецФункции

#КонецОбласти

#Область Отладка

// Записать данные для отладки в справочник.
// 
// Параметры:
//  ТипОбъектаОтладки - Строка - Тип объекта отладки
//  ДанныеДляОтладки - Произвольный -Данные для отладки
//  Наименование - Строка - Наименование
// 
// Возвращаемое значение:
//  Строка -СсылкаНаДанныеОтладки
// Результат выполнения сохранения данных отладки
// 	
Функция ЗаписатьДанныеДляОтладкиВСправочник(ТипОбъектаОтладки, ДанныеДляОтладки, Наименование = "") Экспорт
	КлючНастроек=ТипОбъектаОтладки + "/" + ИмяПользователя() + "/" + Формат(ТекущаяДата(), "ДФ=yyyyMMddHHmmss;");
	Если ЗначениеЗаполнено(Наименование) Тогда
		КлючНастроек = КлючНастроек + "/" + Наименование;
	КонецЕсли;
	
	КлючОбъектаДанныхОтладки=УИ_ОбщегоНазначенияКлиентСервер.КлючДанныхОбъектаДанныхОтладкиВХранилищеНастроек();
	Если ТранзакцияАктивна() Тогда
		ПараметрыПроцедуры = Новый Структура;
		ПараметрыПроцедуры.Вставить("КлючОбъекта", КлючОбъектаДанныхОтладки);
		ПараметрыПроцедуры.Вставить("КлючНастроек", КлючНастроек);
		ПараметрыПроцедуры.Вставить("Настройки", ДанныеДляОтладки);

		ПараметрыВыполнения = УИ_ДлительныеОперации.ПараметрыВыполненияВФоне(Неопределено);
		ПараметрыВыполнения.Вставить("ЗапуститьВФоне", Истина);

		УИ_ДлительныеОперации.ВыполнитьВФоне("УИ_ОбщегоНазначения.ХранилищеСистемныхНастроекСохранитьВФоне",
											 ПараметрыПроцедуры,
											 ПараметрыВыполнения);
		Сообщение = "Запись будет выполнена в фоне. Ключ настроек " + КлючНастроек;
	Иначе
		УИ_ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить(КлючОбъектаДанныхОтладки,
																КлючНастроек,
																ДанныеДляОтладки);
		Сообщение = "Запись выполнена успешно. Ключ настроек " + КлючНастроек;
	КонецЕсли;
	Возврат Сообщение;
КонецФункции

Функция СтруктураДанныхОбъектаОтладкиИзСправочникаДанныхОтладки(СсылкаНаДанные) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ТипОбъектаОтладки", СсылкаНаДанные.ТипОбъектаОтладки);
	Результат.Вставить("АдресОбъектаОтладки", ПоместитьВоВременноеХранилище(
		СсылкаНаДанные.ХранилищеОбъектаОтладки.Получить()));

	Возврат Результат;
КонецФункции

Функция СтруктураДанныхОбъектаОтладкиИзСистемногоХранилищаНастроек(КлючНастроек, Пользователь = Неопределено,
	ИдентификаторФормы = Неопределено) Экспорт
	КлючОбъектаДанныхОтладки=УИ_ОбщегоНазначенияКлиентСервер.КлючДанныхОбъектаДанныхОтладкиВХранилищеНастроек();
	НастройкиОтладки=УИ_ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(КлючОбъектаДанныхОтладки, КлючНастроек, , ,
		Пользователь);

	Если НастройкиОтладки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	МассивПодСтрокКлюча=СтрРазделить(КлючНастроек, "/");

	Если ИдентификаторФормы=Неопределено Тогда
		АдресОбъектаОтладки=ПоместитьВоВременноеХранилище(НастройкиОтладки);
	Иначе
		АдресОбъектаОтладки=ПоместитьВоВременноеХранилище(НастройкиОтладки, ИдентификаторФормы);
	КонецЕсли;

	Результат = Новый Структура;
	Результат.Вставить("ТипОбъектаОтладки", МассивПодСтрокКлюча[0]);
	Результат.Вставить("АдресОбъектаОтладки", АдресОбъектаОтладки);

	Возврат Результат;
КонецФункции

Функция СериализоватьОбъектСКДДляОтладки(СКД, НастройкиСКД, ВнешниеНаборыДанных) Экспорт
	СтруктураОбъекта = Новый Структура;

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, СКД, "dataCompositionSchema",
		"http://v8.1c.ru/8.1/data-composition-system/schema");

	СтруктураОбъекта.Вставить("ТекстСКД", ЗаписьXML.Закрыть());

	Если НастройкиСКД = Неопределено Тогда
		Настройки=СКД.НастройкиПоУмолчанию;
	Иначе
		Настройки=НастройкиСКД;

	КонецЕсли;

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Настройки, "Settings",
		"http://v8.1c.ru/8.1/data-composition-system/settings");
	СтруктураОбъекта.Вставить("ТекстНастроекСКД", ЗаписьXML.Закрыть());

	Если ТипЗнч(ВнешниеНаборыДанных) = Тип("Структура") Тогда
		Наборы=Новый Структура;

		Для Каждого КлючЗначение ИЗ ВнешниеНаборыДанных Цикл
			Если ТипЗнч(КлючЗначение.Значение) <> Тип("ТаблицаЗначений") Тогда
				Продолжить;
			КонецЕсли;

			Наборы.Вставить(КлючЗначение.Ключ, ЗначениеВСтрокуВнутр(КлючЗначение.Значение));
		КонецЦикла;

		Если Наборы.Количество() > 0 Тогда
			СтруктураОбъекта.Вставить("ВнешниеНаборыДанных", Наборы);
		КонецЕсли;
	КонецЕсли;

	Возврат СтруктураОбъекта;

КонецФункции

Функция СтруктураВременныхТаблицМенеджераВременныхТаблиц(МенеджерВременныхТаблиц) Экспорт
	СтруктураВременныхТаблиц = Новый Структура;
	Для Каждого ТаблицаВТ Из МенеджерВременныхТаблиц.Таблицы Цикл
		СтруктураВременныхТаблиц.Вставить(ТаблицаВТ.ПолноеИмя, ТаблицаВТ.ПолучитьДанные().Выгрузить());
	КонецЦикла;

	Возврат СтруктураВременныхТаблиц;
КонецФункции

//https://infostart.ru/public/1207287/
Функция ВыполнитьСравнениеДвухТаблицЗначений(ТаблицаБазовая, ТаблицаСравнения, СписокКолонокСравнения) Экспорт
	СписокКолонок = УИ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СписокКолонокСравнения, ",", Истина);
	//Результирующая таблица
	ВременнаяТаблица = Новый ТаблицаЗначений;
	Для Каждого Колонка Из СписокКолонок Цикл
		ВременнаяТаблица.Колонки.Добавить(Колонка);
		ВременнаяТаблица.Колонки.Добавить(Колонка + "Сравнение");
	КонецЦикла;
	ВременнаяТаблица.Колонки.Добавить("НомерСтр");
	ВременнаяТаблица.Колонки.Добавить("НомерСтр" + "Сравнение");
	//---------
	СравниваемаяТаблица = ТаблицаСравнения.Скопировать();
	СравниваемаяТаблица.Колонки.Добавить("УжеИспользуем", Новый ОписаниеТипов("Булево"));

	Для Каждого Строка Из ТаблицаБазовая Цикл
		НоваяСтрока = ВременнаяТаблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НоваяСтрока.НомерСтр = Строка.НомерСтроки;
		//формируем структуру для поиска по заданному сопоставлению
		ОтборДляПоискаСтрок = Новый Структура("УжеИспользуем", Ложь);
		Для Каждого Колонка Из СписокКолонок Цикл
			ОтборДляПоискаСтрок.Вставить(Колонка, Строка[Колонка]);
		КонецЦикла;

		НайдемСтроки = СравниваемаяТаблица.НайтиСтроки(ОтборДляПоискаСтрок);
		Если НайдемСтроки.Количество() > 0 Тогда
			СтрокаСопоставления = НайдемСтроки[0];
			НоваяСтрока.НомерСтрСравнение = СтрокаСопоставления.НомерСтроки;
			Для Каждого Колонка Из СписокКолонок Цикл
				Реквизит = Колонка + "Сравнение";
				НоваяСтрока[Реквизит] = СтрокаСопоставления[Колонка];
			КонецЦикла;
			СтрокаСопоставления.УжеИспользуем = Истина;
		КонецЕсли;
	КонецЦикла;
	//Смотрим что осталось +++
	ОтборДляПоискаСтрок = Новый Структура("УжеИспользуем", Ложь);
	НайдемСтроки = СравниваемаяТаблица.НайтиСтроки(ОтборДляПоискаСтрок);
	Для Каждого Строка Из НайдемСтроки Цикл
		НоваяСтрока = ВременнаяТаблица.Добавить();
		НоваяСтрока.НомерСтрСравнение = Строка.НомерСтроки;
		Для Каждого Колонка Из СписокКолонок Цикл
			Реквизит = Колонка + "Сравнение";
			НоваяСтрока[Реквизит] = Строка[Колонка];
		КонецЦикла;
	КонецЦикла;
	//Проверяем что получилось
	ТаблицыИдентичны = Истина;
	Для Каждого Строка Из ВременнаяТаблица Цикл
		Для Каждого Колонка Из СписокКолонок Цикл
			Если (Не ЗначениеЗаполнено(Строка[Колонка])) Или (Не ЗначениеЗаполнено(Строка[Колонка + "Сравнение"])) Тогда
				ТаблицыИдентичны = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не ТаблицыИдентичны Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат Новый Структура("ИдентичныеТаблицы,ТаблицаРасхождений", ТаблицыИдентичны, ВременнаяТаблица);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СохранениеЧтениеДанныхКонсолей

Функция ПодготовленныеДанныеКонсолиДляЗаписиВФайл(ИмяКонсоли, ИмяФайла, АдресДанныхСохранения,
	СтруктураОписанияСохраняемогоФайла) Экспорт
	Файл=Новый Файл(ИмяФайла);

	Если ЭтоАдресВременногоХранилища(АдресДанныхСохранения) Тогда
		ДанныеСохранения=ПолучитьИзВременногоХранилища(АдресДанныхСохранения);
	Иначе
		ДанныеСохранения=АдресДанныхСохранения;
	КонецЕсли;

	Если ВРег(ИмяКонсоли) = "КОНСОЛЬHTTPЗАПРОСОВ" Тогда
		МенеджерКонсоли=Обработки.УИ_КонсольHTTPЗапросов;
	Иначе
		МенеджерКонсоли=Неопределено;
	КонецЕсли;

	Если МенеджерКонсоли = Неопределено Тогда
		Если ТипЗнч(ДанныеСохранения) = Тип("Строка") Тогда
			НовыеДанныеСохранения=ДанныеСохранения;
		Иначе
			НовыеДанныеСохранения=ЗначениеВСтрокуВнутр(ДанныеСохранения);
		КонецЕсли;
	Иначе
		Попытка
			НовыеДанныеСохранения=МенеджерКонсоли.СериализованныеДанныеСохранения(Файл.Расширение, ДанныеСохранения);
		Исключение
			НовыеДанныеСохранения=ЗначениеВСтрокуВнутр(ДанныеСохранения);
		КонецПопытки;
	КонецЕсли;

	Поток=Новый ПотокВПамяти;
	ЗаписьТекста=Новый ЗаписьДанных(Поток);
	ЗаписьТекста.ЗаписатьСтроку(НовыеДанныеСохранения);

	Возврат ПоместитьВоВременноеХранилище(Поток.ЗакрытьИПолучитьДвоичныеДанные());
	
//	Возврат НовыеДанныеСохранения;	

КонецФункции

#КонецОбласти