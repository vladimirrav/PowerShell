# Импорт/загрузка модуля для работы с базами данных SQL, если это необходимо
# Import-Module -Name SqlServer

# Создание функции для генерации буквенного алфавита и их позиций
function Get-AlphabetWithPositions {

	# CreateAnArray to hold single letters fromA to Z
	$singleLetters = @()

	# Создаем массив чисел от 0 до 25 (что соответствует буквам от 'A' до 'Z')
	0..25 | ForEach-Object {
		# Преобразуем смещение в заглавную букву, используя кодировкуASCII
		$letter = [char](65 + $_)
		# Добавляем объект в массив с буквой и её позицией
		$singleLetters += [PSCustomObject]@{
			Letter = $letter
			Position = $_
		}
	}
		
	# CreateAnArray to hold two-letter combinations
	$twoLetters = @()

	# Создаем все возможные комбинации из двух букв
	foreach ($a in $singleLetters) {
		foreach ($b in $singleLetters) {
			# Конкатенируем две буквы
			$concatLetter = $a.Letter + $b.Letter
			# Рассчитываем уникальную позицию для комбинации из двух букв
			$position = 26 + ($a.Position * 26) + $b.Position
			# Добавляем объект в массив с двухбуквенной комбинацией и её позицией
			$twoLetters += [PSCustomObject]@{
				Letter = $concatLetter
				Position = $position
				CalculationDetail = "26 + ($($a.Position) * 26) + $($b.Position) = $position"
			}
		}
	}

	# Объединение всех одиночных и двухбуквенных комбинаций
	$combined = $singleLetters + $twoLetters

	# Сортировка объединенных данных по позиции
	$result = $combined | Sort-Object -Property Position

	# Возвращение и вывод результата с позиции, увеличенной на 1, и буквы
	return $result | ForEach-Object {
		[PSCustomObject]@{
			Position = $_.Position + 1
			Letter = $_.Letter
			CalculationDetail = $_.CalculationDetail
		}
	}
}

# Получение результирующего списка
$result = Get-AlphabetWithPositions

# Вывод результирующего списка на экран
$result | Format-Table -AutoSize
