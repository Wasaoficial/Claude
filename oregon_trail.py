#!/usr/bin/env python3
"""El Sendero de Oregon - Version Terminal"""

import random
import time
import sys
import os

# --- Constantes ---

LANDMARKS = [
    {"nombre": "Independence, Missouri", "km": 0, "rio": False},
    {"nombre": "Rio Kansas", "km": 130, "rio": True, "profundidad": 0.8},
    {"nombre": "Rio Grande Azul", "km": 310, "rio": True, "profundidad": 1.2},
    {"nombre": "Fort Kearney", "km": 500, "rio": False, "fuerte": True},
    {"nombre": "Chimney Rock", "km": 750, "rio": False},
    {"nombre": "Fort Laramie", "km": 900, "rio": False, "fuerte": True},
    {"nombre": "Independence Rock", "km": 1100, "rio": False},
    {"nombre": "South Pass", "km": 1300, "rio": False},
    {"nombre": "Rio Green", "km": 1450, "rio": True, "profundidad": 1.5},
    {"nombre": "Fort Bridger", "km": 1550, "rio": False, "fuerte": True},
    {"nombre": "Soda Springs", "km": 1700, "rio": False},
    {"nombre": "Fort Hall", "km": 1850, "rio": False, "fuerte": True},
    {"nombre": "Rio Snake", "km": 2050, "rio": True, "profundidad": 2.0},
    {"nombre": "Fort Boise", "km": 2200, "rio": False, "fuerte": True},
    {"nombre": "Blue Mountains", "km": 2400, "rio": False},
    {"nombre": "Rio Columbia", "km": 2600, "rio": True, "profundidad": 2.5},
    {"nombre": "The Dalles", "km": 2700, "rio": False},
    {"nombre": "Valle de Willamette, Oregon", "km": 2800, "rio": False},
]

MESES = [
    "enero", "febrero", "marzo", "abril", "mayo", "junio",
    "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre",
]

ENFERMEDADES = [
    "disenteria", "fiebre tifoidea", "colera", "sarampion",
    "difteria", "fiebres", "agotamiento", "pierna rota",
    "mordedura de serpiente", "escorbuto",
]

PROFESIONES = [
    {"nombre": "Banquero de Boston", "dinero": 1600, "multiplicador": 1},
    {"nombre": "Carpintero de Ohio", "dinero": 800, "multiplicador": 2},
    {"nombre": "Granjero de Illinois", "dinero": 400, "multiplicador": 3},
]

CLIMA_TIPOS = ["despejado", "nublado", "lluvia", "tormenta", "niebla", "nieve"]

ANIMALES_CAZA = [
    {"nombre": "conejo", "comida": 3, "dificultad": 6},
    {"nombre": "ardilla", "comida": 2, "dificultad": 5},
    {"nombre": "venado", "comida": 35, "dificultad": 4},
    {"nombre": "alce", "comida": 60, "dificultad": 3},
    {"nombre": "bisonte", "comida": 100, "dificultad": 2},
    {"nombre": "oso", "comida": 80, "dificultad": 3},
]


def limpiar():
    os.system("cls" if os.name == "nt" else "clear")


def pausar(msg="Presiona Enter para continuar..."):
    input(f"\n{msg}")


def escribir(texto, delay=0.02):
    for char in texto:
        sys.stdout.write(char)
        sys.stdout.flush()
        time.sleep(delay)
    print()


def linea(char="=", largo=60):
    print(char * largo)


def centrar(texto, largo=60):
    print(texto.center(largo))


def menu_opcion(opciones, prompt="Tu eleccion: "):
    while True:
        try:
            eleccion = int(input(prompt))
            if 1 <= eleccion <= len(opciones):
                return eleccion
            print(f"Elige entre 1 y {len(opciones)}.")
        except ValueError:
            print("Ingresa un numero valido.")


def obtener_mes_dia(dia_total):
    dia_total = dia_total % 365
    meses_dias = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    mes_idx = 0
    while dia_total >= meses_dias[mes_idx]:
        dia_total -= meses_dias[mes_idx]
        mes_idx = (mes_idx + 1) % 12
    return MESES[mes_idx], dia_total + 1


def obtener_clima(mes):
    if mes in ("diciembre", "enero", "febrero"):
        pesos = [10, 15, 20, 15, 10, 30]
    elif mes in ("marzo", "abril", "mayo"):
        pesos = [25, 20, 25, 15, 10, 5]
    elif mes in ("junio", "julio", "agosto"):
        pesos = [40, 20, 20, 10, 5, 5]
    else:
        pesos = [20, 20, 25, 15, 10, 10]
    return random.choices(CLIMA_TIPOS, weights=pesos, k=1)[0]


class Persona:
    def __init__(self, nombre):
        self.nombre = nombre
        self.vivo = True
        self.salud = 100
        self.enfermedad = None
        self.dias_enfermo = 0

    def estado(self):
        if not self.vivo:
            return "muerto/a"
        if self.enfermedad:
            return f"enfermo/a ({self.enfermedad})"
        if self.salud > 70:
            return "bien"
        if self.salud > 40:
            return "debil"
        return "muy mal"


class Juego:
    def __init__(self):
        self.nombre_lider = ""
        self.grupo = []
        self.profesion = None
        self.dinero = 0
        self.comida = 0
        self.balas = 0
        self.ropa = 0
        self.bueyes = 0
        self.repuestos = 0
        self.km_recorridos = 0
        self.km_totales = 2800
        self.dia = 0
        self.dia_inicio = 0  # dia del anio en que partimos
        self.ritmo = "normal"  # lento, normal, rapido
        self.raciones = "normal"  # escasas, normal, abundantes
        self.siguiente_landmark = 1
        self.jugando = True
        self.gano = False
        self.puntuacion = 0

    def pantalla_titulo(self):
        limpiar()
        linea("*")
        print()
        centrar("E L   S E N D E R O   D E   O R E G O N")
        print()
        centrar("~ Version Terminal ~")
        centrar("1848")
        print()
        linea("*")
        print()
        escribir("El anio es 1848. Tu familia se ha unido a una")
        escribir("caravana de carretas rumbo al Valle de Willamette")
        escribir("en Oregon. El viaje de 2800 km desde Independence,")
        escribir("Missouri, sera largo y peligroso.")
        print()
        escribir("Deberas cazar, cruzar rios, sobrevivir enfermedades")
        escribir("y tomar decisiones que determinaran si tu grupo")
        escribir("llega con vida a Oregon.")
        pausar()

    def elegir_profesion(self):
        limpiar()
        linea()
        centrar("ELIGE TU PROFESION")
        linea()
        print()
        for i, p in enumerate(PROFESIONES, 1):
            bonus = ""
            if p["multiplicador"] > 1:
                bonus = f" (puntos x{p['multiplicador']})"
            print(f"  {i}. {p['nombre']} - ${p['dinero']}{bonus}")
        print()
        print("Un banquero tiene mas dinero pero menos puntos.")
        print("Un granjero tiene poco dinero pero triplica puntos.")
        print()
        eleccion = menu_opcion(PROFESIONES)
        self.profesion = PROFESIONES[eleccion - 1]
        self.dinero = self.profesion["dinero"]

    def nombrar_grupo(self):
        limpiar()
        linea()
        centrar("TU GRUPO DE VIAJE")
        linea()
        print()
        self.nombre_lider = input("Nombre del lider de la caravana: ").strip()
        if not self.nombre_lider:
            self.nombre_lider = "Jugador"
        self.grupo = [Persona(self.nombre_lider)]
        print()
        for i in range(4):
            nombre = input(f"Nombre del miembro #{i+2}: ").strip()
            if not nombre:
                nombre = f"Viajero {i+2}"
            self.grupo.append(Persona(nombre))
        print()
        print("Tu grupo:")
        for p in self.grupo:
            print(f"  - {p.nombre}")

    def tienda(self, es_fuerte=False):
        limpiar()
        linea()
        if es_fuerte:
            centrar("TIENDA DEL FUERTE")
        else:
            centrar("TIENDA DE MATT - Independence, Missouri")
        linea()
        print()

        precio_buey = 40 if not es_fuerte else random.randint(35, 55)
        precio_comida = 1 if not es_fuerte else random.randint(1, 2)
        precio_ropa = 10 if not es_fuerte else random.randint(8, 15)
        precio_balas = 2 if not es_fuerte else random.randint(2, 4)
        precio_repuesto = 10 if not es_fuerte else random.randint(8, 18)

        items = [
            ("Bueyes (por par)", precio_buey, "bueyes"),
            ("Libras de comida", precio_comida, "comida"),
            ("Juegos de ropa", precio_ropa, "ropa"),
            ("Cajas de balas (20 c/u)", precio_balas, "balas"),
            ("Repuestos de carreta", precio_repuesto, "repuestos"),
        ]

        for nombre, precio, attr in items:
            print(f"\nDinero disponible: ${self.dinero:.2f}")
            print(f"{nombre} - ${precio} c/u")

            if attr == "bueyes" and not es_fuerte:
                print("(Necesitas al menos 2 pares para el viaje)")
            if attr == "comida" and not es_fuerte:
                print("(Recomendado: 200+ libras para empezar)")

            while True:
                try:
                    cant = int(input(f"Cuantos compras? (0 para saltar): "))
                    if cant < 0:
                        print("No puedes comprar cantidades negativas.")
                        continue
                    costo = cant * precio
                    if costo > self.dinero:
                        print(f"No te alcanza. Tienes ${self.dinero:.2f}.")
                        continue
                    self.dinero -= costo
                    if attr == "bueyes":
                        self.bueyes += cant * 2
                    elif attr == "balas":
                        self.balas += cant * 20
                    elif attr == "comida":
                        self.comida += cant
                    elif attr == "ropa":
                        self.ropa += cant
                    elif attr == "repuestos":
                        self.repuestos += cant
                    break
                except ValueError:
                    print("Ingresa un numero valido.")

        print(f"\nDinero restante: ${self.dinero:.2f}")

    def elegir_mes_partida(self):
        limpiar()
        linea()
        centrar("FECHA DE PARTIDA")
        linea()
        print()
        print("Cuando quieres partir?")
        print()
        meses_partida = [
            ("Marzo", 59),
            ("Abril", 90),
            ("Mayo", 120),
            ("Junio", 151),
            ("Julio", 181),
        ]
        for i, (nombre, _) in enumerate(meses_partida, 1):
            print(f"  {i}. {nombre}")
        print()
        print("Consejo: Partir en abril o mayo es lo ideal.")
        print("Muy temprano: frio y poca hierba. Muy tarde: nieve en las montanias.")
        print()
        eleccion = menu_opcion(meses_partida)
        self.dia_inicio = meses_partida[eleccion - 1][1]
        self.dia = 0

    def fecha_actual(self):
        return obtener_mes_dia(self.dia_inicio + self.dia)

    def vivos(self):
        return [p for p in self.grupo if p.vivo]

    def mostrar_estado(self):
        limpiar()
        mes, dia_mes = self.fecha_actual()
        clima = obtener_clima(mes)

        linea("-")
        print(f"  Fecha: {dia_mes} de {mes}, 1848    Clima: {clima}")
        linea("-")

        progreso = self.km_recorridos / self.km_totales
        barra_len = 40
        lleno = int(progreso * barra_len)
        barra = "[" + "#" * lleno + "." * (barra_len - lleno) + "]"
        print(f"  {barra} {self.km_recorridos}/{self.km_totales} km")
        print()

        siguiente = LANDMARKS[self.siguiente_landmark]
        dist_sig = siguiente["km"] - self.km_recorridos
        print(f"  Proximo: {siguiente['nombre']} ({dist_sig} km)")
        print()

        linea("-")
        print(f"  Comida: {self.comida} lb   Balas: {self.balas}   Ropa: {self.ropa}")
        print(f"  Bueyes: {self.bueyes}   Repuestos: {self.repuestos}   Dinero: ${self.dinero:.2f}")
        linea("-")
        print(f"  Ritmo: {self.ritmo}   Raciones: {self.raciones}")
        linea("-")
        print("  Grupo:")
        for p in self.grupo:
            estado = p.estado()
            indicador = "+" if p.vivo else "x"
            print(f"    [{indicador}] {p.nombre}: {estado} (salud: {p.salud})" if p.vivo else f"    [x] {p.nombre}: fallecido/a")
        linea("-")

        return clima

    def menu_principal(self):
        print()
        print("  1. Continuar viaje")
        print("  2. Cambiar ritmo")
        print("  3. Cambiar raciones")
        print("  4. Descansar")
        print("  5. Cazar")
        print("  6. Ver mapa")
        print()
        return menu_opcion(range(1, 7))

    def cambiar_ritmo(self):
        print()
        print("  1. Lento    (10-12 km/dia, menos desgaste)")
        print("  2. Normal   (15-18 km/dia, desgaste moderado)")
        print("  3. Rapido   (20-25 km/dia, mas desgaste)")
        print()
        r = menu_opcion(range(1, 4))
        self.ritmo = ["lento", "normal", "rapido"][r - 1]
        print(f"Ritmo cambiado a: {self.ritmo}")

    def cambiar_raciones(self):
        print()
        print("  1. Escasas    (1 lb/persona/dia - riesgo de hambre)")
        print("  2. Normales   (2 lb/persona/dia)")
        print("  3. Abundantes (3 lb/persona/dia - mejor salud)")
        print()
        r = menu_opcion(range(1, 4))
        self.raciones = ["escasas", "normal", "abundantes"][r - 1]
        print(f"Raciones cambiadas a: {self.raciones}")

    def descansar(self):
        dias = 0
        while True:
            try:
                dias = int(input("Cuantos dias quieres descansar? (1-9): "))
                if 1 <= dias <= 9:
                    break
                print("Entre 1 y 9 dias.")
            except ValueError:
                print("Numero valido por favor.")

        consumo = self.consumo_comida_diario()
        for _ in range(dias):
            self.dia += 1
            self.comida -= consumo
            if self.comida < 0:
                self.comida = 0
            for p in self.vivos():
                p.salud = min(100, p.salud + random.randint(3, 8))
                if p.enfermedad and random.random() < 0.3:
                    p.enfermedad = None
                    p.dias_enfermo = 0
                    print(f"  {p.nombre} se ha recuperado!")
        print(f"Descansaste {dias} dias. Tu grupo se siente mejor.")

    def cazar(self):
        if self.balas <= 0:
            print("No tienes balas para cazar!")
            return

        print()
        print("Saliste a cazar...")
        print()
        balas_usadas = random.randint(3, 12)
        self.balas = max(0, self.balas - balas_usadas)

        encuentros = random.randint(1, 3)
        comida_total = 0

        for _ in range(encuentros):
            animal = random.choice(ANIMALES_CAZA)
            exito = random.randint(1, 10) <= animal["dificultad"]
            if exito:
                comida_ganada = animal["comida"] + random.randint(-5, 10)
                comida_ganada = max(1, comida_ganada)
                comida_total += comida_ganada
                print(f"  Cazaste un {animal['nombre']}! (+{comida_ganada} lb de comida)")
            else:
                print(f"  Fallaste el tiro al {animal['nombre']}.")

        if comida_total > 100:
            comida_total = 100
            print("  Solo puedes cargar 100 lb de vuelta al campamento.")

        self.comida += comida_total
        print(f"\nUsaste {balas_usadas} balas. Conseguiste {comida_total} lb de comida.")
        self.dia += 1
        self.comida -= self.consumo_comida_diario()
        if self.comida < 0:
            self.comida = 0

    def ver_mapa(self):
        limpiar()
        linea()
        centrar("MAPA DEL SENDERO DE OREGON")
        linea()
        print()
        for lm in LANDMARKS:
            dist = lm["km"]
            marcador = ">>>" if dist <= self.km_recorridos else "   "
            rio = " ~rio~" if lm.get("rio") else ""
            fuerte = " [fuerte]" if lm.get("fuerte") else ""
            if self.siguiente_landmark < len(LANDMARKS) and LANDMARKS[self.siguiente_landmark]["km"] == dist and dist > self.km_recorridos:
                marcador = "-->"
            print(f"  {marcador} km {dist:>5}: {lm['nombre']}{rio}{fuerte}")
        print()
        print(f"  Tu posicion: km {self.km_recorridos}")
        pausar()

    def consumo_comida_diario(self):
        n_vivos = len(self.vivos())
        if self.raciones == "escasas":
            return n_vivos * 1
        elif self.raciones == "abundantes":
            return n_vivos * 3
        return n_vivos * 2

    def km_por_dia(self):
        base = {"lento": 11, "normal": 16, "rapido": 22}[self.ritmo]
        variacion = random.randint(-3, 3)
        if self.bueyes <= 1:
            base = base // 3
        elif self.bueyes <= 2:
            base = base // 2
        return max(1, base + variacion)

    def viajar(self, clima):
        dias_viaje = random.randint(3, 7)
        km_total = 0
        eventos = []

        for d in range(dias_viaje):
            self.dia += 1

            km_hoy = self.km_por_dia()
            if clima in ("tormenta", "nieve"):
                km_hoy = km_hoy // 2
            km_total += km_hoy
            self.km_recorridos += km_hoy

            consumo = self.consumo_comida_diario()
            self.comida -= consumo
            if self.comida <= 0:
                self.comida = 0
                eventos.append("Se acabó la comida!")
                for p in self.vivos():
                    p.salud -= random.randint(8, 15)

            if self.raciones == "escasas":
                for p in self.vivos():
                    p.salud -= random.randint(0, 3)
            elif self.raciones == "abundantes":
                for p in self.vivos():
                    p.salud = min(100, p.salud + random.randint(0, 2))

            if self.ritmo == "rapido":
                for p in self.vivos():
                    p.salud -= random.randint(1, 4)

            if clima == "nieve":
                for p in self.vivos():
                    if self.ropa <= 0:
                        p.salud -= random.randint(3, 8)
                        if "frio" not in [e for e in eventos]:
                            eventos.append("El frio sin ropa adecuada esta afectando al grupo.")

            for p in self.vivos():
                if p.enfermedad:
                    p.dias_enfermo += 1
                    p.salud -= random.randint(3, 7)
                    if p.dias_enfermo > 5 and random.random() < 0.15:
                        p.enfermedad = None
                        p.dias_enfermo = 0

            self.evento_aleatorio(eventos)

            for p in self.vivos():
                if p.salud <= 0:
                    p.vivo = False
                    p.salud = 0
                    eventos.append(f"{p.nombre} ha fallecido.")

            if self.siguiente_landmark < len(LANDMARKS):
                if self.km_recorridos >= LANDMARKS[self.siguiente_landmark]["km"]:
                    lm = LANDMARKS[self.siguiente_landmark]
                    eventos.append(f"Llegaste a {lm['nombre']}!")
                    self.siguiente_landmark += 1
                    if self.km_recorridos >= self.km_totales:
                        self.gano = True
                        return km_total, dias_viaje, eventos
                    if lm.get("rio"):
                        self.cruzar_rio(lm, eventos)
                    break

            if not self.vivos():
                self.jugando = False
                return km_total, dias_viaje, eventos

        return km_total, dias_viaje, eventos

    def evento_aleatorio(self, eventos):
        r = random.random()

        if r < 0.04:
            victima = random.choice(self.vivos())
            enfermedad = random.choice(ENFERMEDADES)
            if not victima.enfermedad:
                victima.enfermedad = enfermedad
                victima.dias_enfermo = 0
                eventos.append(f"{victima.nombre} tiene {enfermedad}.")

        elif r < 0.06:
            if self.repuestos > 0:
                self.repuestos -= 1
                eventos.append("Se rompio una rueda de la carreta. Usaste un repuesto.")
            else:
                eventos.append("Se rompio una rueda y no tienes repuestos! Perdiste 3 dias reparando.")
                self.dia += 3
                self.comida -= self.consumo_comida_diario() * 3

        elif r < 0.08:
            if self.bueyes > 2:
                self.bueyes -= 1
                eventos.append("Un buey murio por agotamiento.")

        elif r < 0.09:
            robado = random.randint(10, 50)
            self.comida = max(0, self.comida - robado)
            eventos.append(f"Ladrones robaron {robado} lb de comida durante la noche!")

        elif r < 0.10:
            perdido = random.randint(5, 20)
            self.balas = max(0, self.balas - perdido)
            eventos.append(f"Se mojaron {perdido} balas al cruzar un arroyo.")

        elif r < 0.12:
            encontrado = random.randint(5, 30)
            self.comida += encontrado
            eventos.append(f"Encontraste {encontrado} lb de comida en una carreta abandonada.")

        elif r < 0.13:
            self.ropa = max(0, self.ropa - 1)
            if self.ropa >= 0:
                eventos.append("Un juego de ropa se danio en el camino.")

        elif r < 0.14:
            for p in self.vivos():
                p.salud = min(100, p.salud + random.randint(1, 5))
            eventos.append("Encontraron agua fresca y buen pasto. El grupo descansa bien.")

        elif r < 0.145:
            self.dinero += random.randint(5, 25)
            eventos.append("Un viajero te pago por ayudarlo a reparar su carreta.")

    def cruzar_rio(self, landmark, eventos):
        prof = landmark.get("profundidad", 1.0)
        print()
        linea("~")
        print(f"  Has llegado a {landmark['nombre']}")
        print(f"  Profundidad estimada: {prof:.1f} metros")
        print()
        print("  1. Vadear el rio (gratis, riesgoso si es profundo)")
        print("  2. Flotar la carreta ($10-30, mas seguro)")
        print("  3. Esperar y ver (1-3 dias, puede bajar el nivel)")
        print()
        eleccion = menu_opcion(range(1, 4))

        if eleccion == 1:
            riesgo = prof / 3.0
            if random.random() < riesgo:
                perdida_comida = random.randint(20, 60)
                self.comida = max(0, self.comida - perdida_comida)
                self.ropa = max(0, self.ropa - random.randint(0, 2))
                eventos.append(f"El rio arrastro parte de tus provisiones! (-{perdida_comida} lb comida)")
                if random.random() < riesgo * 0.3:
                    victima = random.choice(self.vivos())
                    victima.salud -= random.randint(15, 40)
                    eventos.append(f"{victima.nombre} casi se ahoga cruzando el rio!")
            else:
                eventos.append("Cruzaste el rio sin problemas.")

        elif eleccion == 2:
            costo = int(10 + prof * 10)
            if self.dinero >= costo:
                self.dinero -= costo
                if random.random() < 0.1:
                    self.comida = max(0, self.comida - random.randint(5, 15))
                    eventos.append(f"Cruzaste flotando pero se mojo algo de comida. (-${costo})")
                else:
                    eventos.append(f"Cruzaste el rio flotando sin problemas. (-${costo})")
            else:
                eventos.append("No tienes dinero suficiente! Intentas vadear...")
                riesgo = prof / 3.0
                if random.random() < riesgo:
                    perdida = random.randint(10, 40)
                    self.comida = max(0, self.comida - perdida)
                    eventos.append(f"Perdiste {perdida} lb de comida en el cruce.")

        elif eleccion == 3:
            dias = random.randint(1, 3)
            self.dia += dias
            self.comida -= self.consumo_comida_diario() * dias
            if self.comida < 0:
                self.comida = 0
            if random.random() < 0.5:
                eventos.append(f"Esperaste {dias} dias y el rio bajo. Cruzaste bien.")
            else:
                eventos.append(f"Esperaste {dias} dias pero el rio no bajo mucho. Cruzaste con dificultad.")
                if random.random() < 0.3:
                    self.comida = max(0, self.comida - random.randint(5, 20))

        linea("~")

    def comerciar_fuerte(self, nombre_fuerte):
        print()
        print(f"Llegaste a {nombre_fuerte}.")
        print("Quieres visitar la tienda? (s/n): ", end="")
        resp = input().strip().lower()
        if resp in ("s", "si"):
            self.tienda(es_fuerte=True)

    def mostrar_eventos(self, eventos):
        if not eventos:
            print("  El viaje transcurrio sin novedades.")
            return
        print()
        for e in eventos:
            print(f"  * {e}")

    def pantalla_derrota(self):
        limpiar()
        linea("=")
        print()
        centrar("G A M E   O V E R")
        print()
        linea("=")
        print()
        escribir("Nadie de tu grupo sobrevivio el viaje.", 0.04)
        escribir(f"Llegaste hasta el km {self.km_recorridos} de {self.km_totales}.", 0.04)
        mes, dia_mes = self.fecha_actual()
        print(f"Fecha: {dia_mes} de {mes}, 1848")
        print()
        print("Los que partieron:")
        for p in self.grupo:
            print(f"  - {p.nombre}")
        print()
        escribir("El sendero se cobra otro precio...", 0.05)

    def pantalla_victoria(self):
        limpiar()
        linea("*")
        print()
        centrar("F E L I C I D A D E S !")
        print()
        centrar("Llegaste al Valle de Willamette, Oregon!")
        print()
        linea("*")
        print()

        sobrevivientes = self.vivos()
        mes, dia_mes = self.fecha_actual()
        print(f"Fecha de llegada: {dia_mes} de {mes}, 1848")
        print(f"Sobrevivientes: {len(sobrevivientes)} de {len(self.grupo)}")
        print()
        print("Sobrevivieron:")
        for p in sobrevivientes:
            print(f"  - {p.nombre} (salud: {p.salud})")
        print()
        print("No lo lograron:")
        muertos = [p for p in self.grupo if not p.vivo]
        if muertos:
            for p in muertos:
                print(f"  - {p.nombre}")
        else:
            print("  Todos sobrevivieron!")
        print()

        puntos_base = 500
        puntos_salud = sum(p.salud for p in sobrevivientes) * 2
        puntos_sobrevivientes = len(sobrevivientes) * 100
        puntos_comida = self.comida
        puntos_dinero = int(self.dinero)
        multiplicador = self.profesion["multiplicador"]

        subtotal = puntos_base + puntos_salud + puntos_sobrevivientes + puntos_comida + puntos_dinero
        self.puntuacion = subtotal * multiplicador

        linea("-")
        centrar("PUNTUACION")
        linea("-")
        print(f"  Llegar a Oregon:      {puntos_base}")
        print(f"  Salud del grupo:      {puntos_salud}")
        print(f"  Sobrevivientes (x100): {puntos_sobrevivientes}")
        print(f"  Comida restante:      {puntos_comida}")
        print(f"  Dinero restante:      {puntos_dinero}")
        print(f"  Subtotal:             {subtotal}")
        print(f"  Multiplicador ({self.profesion['nombre']}): x{multiplicador}")
        linea("-")
        print(f"  PUNTUACION FINAL:     {self.puntuacion}")
        linea("-")

    def verificar_landmark_fuerte(self):
        if self.siguiente_landmark > 0:
            lm = LANDMARKS[self.siguiente_landmark - 1]
            if lm.get("fuerte") and self.km_recorridos >= lm["km"]:
                self.comerciar_fuerte(lm["nombre"])

    def iniciar(self):
        self.pantalla_titulo()
        self.elegir_profesion()
        self.nombrar_grupo()
        pausar()
        self.elegir_mes_partida()
        self.tienda()
        pausar("Listo! Presiona Enter para comenzar el viaje...")

        ultimo_fuerte_visitado = 0

        while self.jugando:
            if not self.vivos():
                self.jugando = False
                break

            clima = self.mostrar_estado()
            accion = self.menu_principal()

            if accion == 1:
                km, dias, eventos = self.viajar(clima)
                limpiar()
                linea()
                centrar("RESUMEN DEL TRAMO")
                linea()
                print(f"  Avanzaste {km} km en {dias} dias.")
                self.mostrar_eventos(eventos)

                if self.gano:
                    pausar()
                    self.pantalla_victoria()
                    self.jugando = False
                    break

                if not self.vivos():
                    pausar()
                    self.pantalla_derrota()
                    self.jugando = False
                    break

                if self.siguiente_landmark - 1 > ultimo_fuerte_visitado:
                    lm_actual = LANDMARKS[self.siguiente_landmark - 1]
                    if lm_actual.get("fuerte"):
                        ultimo_fuerte_visitado = self.siguiente_landmark - 1
                        self.comerciar_fuerte(lm_actual["nombre"])

                pausar()

            elif accion == 2:
                self.cambiar_ritmo()
                pausar()
            elif accion == 3:
                self.cambiar_raciones()
                pausar()
            elif accion == 4:
                self.descansar()
                pausar()
            elif accion == 5:
                self.cazar()
                pausar()
            elif accion == 6:
                self.ver_mapa()

        print()
        print("Gracias por jugar El Sendero de Oregon!")
        print()


if __name__ == "__main__":
    try:
        juego = Juego()
        juego.iniciar()
    except KeyboardInterrupt:
        print("\n\nViaje cancelado. Hasta la proxima!")
