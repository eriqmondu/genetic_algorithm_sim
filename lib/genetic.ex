defmodule Genetic do
  @moduledoc """
  Documentation for Genetic.
  """

  @doc """
  Algoritmo Genético para obtener el mejor especimen
  """
  def main(_args) do

    #obtengo muestra aleatoria de personajes
    gen1 = obtener_poblacion_inicial()
    #comienzo el algoritmo genético
    gen_start(gen1, 1)

  end
  #funcion de calidad, suma de las caracteristicas del personaje.
  def fitness(elem) do
      Enum.sum(elem)
  end

  def gen_start(poblacion, count) do
    IO.puts("*********************************************************")
    IO.puts("GENERACIÓN " <> Integer.to_string(count))
    IO.puts("    C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 VALUE")
    imprimir(poblacion, 0)


    #selecciona a los más aptos de la poblacion utilizando la funcion fitness
    #descartando a los personajes que tengan un valor menor a 24
    selected = seleccion(poblacion, [])
    IO.puts("\nLos más aptos (fitness >= 24) de la generación " <> Integer.to_string(count) <> " fueron:")
    IO.puts("    C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 VALUE")
    imprimir(selected, 0)



    IO.puts("\nNueva poblacion al cruzar y mutar aleatoriamente entre los más aptos")
    #cruza y mutación de los más "aptos"
    nueva_poblacion = cruzar_seleccionados(selected, [])
    #dos_hijos = cruza(Enum.random(select), Enum.random(select))
    IO.puts("    C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 VALUE")
    imprimir(nueva_poblacion, 0)

    #vamos a ver si esta generación tiene al especimen perfecto
    false_or_true = imprimir_perfecto(nueva_poblacion, 0)
    #¿Hubo algún personaje perfecto? Sino de nuevo mezcla la población
    if false_or_true == true do
      IO.puts("¡Este personaje de la generación #{count} es PERFECTO!")
      IO.puts("\nLa función de selección descarta a quienes tienen\nun valor fitness < 24 y el personaje objetivo debe\ntener un valor mayor a 40 para ser el perfecto. ")
    else
      #si la poblacion generada es mayor a dos, entonces vuelve a iterar
      if length(nueva_poblacion) >= 2, do: gen_start(nueva_poblacion, count + 1), else: IO.puts("No se pudo generar el especimen perfecto de la población inicial")
    end


  end

  def cruzar_seleccionados(selected, new_population) do
    if length(selected) >= 2 do
      hijos = cruza_y_muta(Enum.random(selected), Enum.random(selected))
      #IO.puts("Nuevos hijos")
      #imprimir(hijos)
      #cruza y concatena con la nueva poblacion
      #IO.inspect(imprimir(selected), label: "seleccionados restantes")
      cruzar_seleccionados(Enum.drop(selected, 1), new_population++hijos)
    else
      new_population
    end
  end


  #funcion de seleccion
  def seleccion(poblacion, aptos) do
    #descarta de la población los personajes que tienen un fitness menor a 24
    [primero|restante] = poblacion

    if fitness(primero) >= 24 do
      #IO.inspect(primero, label: "Individuo apto")
      #IO.inspect(fitness(primero))
      if restante != [], do: seleccion(restante, aptos++[primero]), else: aptos
    else
      #IO.inspect(primero, label: "Individuo no apto")
      #IO.inspect(fitness(primero))
      if restante != [], do: seleccion(restante, aptos), else: aptos
    end


  end


  def cruza_y_muta(padre1, padre2) do
    #Cruce basado en un punto de los atributos (en el 5to atributo)
    #hijo1 tiene las primeras 5 caracteŕisticas del padre1 y las ultimas 5 del padre2
    #hijo2 tiene las primeras 5 caracteŕisticas del padre2 y las ultimas 5 del padre1
    #Intercambio de características
    hijo1 = Enum.slice(padre1, 0..4) ++ Enum.slice(padre2, 5..9)
    hijo2 = Enum.slice(padre2, 0..4) ++ Enum.slice(padre1, 5..9)
    #MUTACIÖN
    #mutacion en cualquier característica reemplazandola por un 5 y un 1 en cada hijo respectivamente
    [List.replace_at(hijo1, random_index(), 5), List.replace_at(hijo2, random_index(), 1)]
  end


  def imprimir(poblacion, count) do
    #asigna cabeza y cola de la lista
    [head|tail] = poblacion
    #imprime cabeza y el valor
    var = head++fitness(head)
    IO.inspect(var, label: "I_#{count}")
    #elimina elemento a la cabeza y llama recursivamente hasta vacio []
    #recursivo

    case tail do
      [] -> :finalizado
      _ -> imprimir(tail, (count + 1)) #sigue imprimiendo el "personaje" numero count y sus caracteristicas
    end
  end


  def imprimir_perfecto(poblacion, count) when poblacion != [] do
    #asigna cabeza y cola de la lista
    [head|tail] = poblacion
    #imprime cabeza y el valor
    var = head++fitness(head)
    if fitness(head) >= 40 do
        IO.inspect(var, label: "\n *I_#{count}")
        true
    else
        case tail do
          [] -> IO.puts("No se encontró el especimen perfecto en esta generación :(")
          false
          _ -> imprimir_perfecto(tail, count + 1)
        end
    end
  end


  def obtener_poblacion_inicial do
    #Genera 10 personajes con 10 características aleatorias del 0 al 5
    min = 0
    max = 5
    1..10 |> Enum.map(fn _ -> 1..10 |> Enum.map(fn _ -> (:rand.uniform() * (max - min) + min) |> Float.round(0) |> trunc() end) end)
  end

  def random_index() do
    #función para elegir cualquier carácterística del C0 al C9 a mutar en el personaje
    trunc(Float.round(:rand.uniform()*(9-0)+0))
  end


end
