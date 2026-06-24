#!/usr/bin/env python3
"""Merge app_en.arb keys into locale ARBs and apply core translations (steps 55–56)."""
from __future__ import annotations

import json
from copy import deepcopy
from pathlib import Path

ARB_DIR = Path(__file__).resolve().parent.parent / "lib" / "l10n"
TEMPLATE = "app_en.arb"

LOCALE_NAMES = {
    "en": {
        "localeGreek": "Greek",
        "localeTurkish": "Turkish",
        "localePortuguese": "Portuguese",
    },
    "ru": {
        "localeGreek": "Греческий",
        "localeTurkish": "Турецкий",
        "localePortuguese": "Португальский",
    },
    "de": {
        "localeGreek": "Griechisch",
        "localeTurkish": "Türkisch",
        "localePortuguese": "Portugiesisch",
    },
    "fr": {
        "localeGreek": "Grec",
        "localeTurkish": "Turc",
        "localePortuguese": "Portugais",
    },
    "es": {
        "localeGreek": "Griego",
        "localeTurkish": "Turco",
        "localePortuguese": "Portugués",
    },
    "it": {
        "localeGreek": "Greco",
        "localeTurkish": "Turco",
        "localePortuguese": "Portoghese",
    },
    "el": {
        "localeGreek": "Ελληνικά",
        "localeTurkish": "Τουρκικά",
        "localePortuguese": "Πορτογαλικά",
        "languageLabel": "Γλώσσα",
        "localeEnglish": "Αγγλικά",
        "localeRussian": "Ρωσικά",
        "localeGerman": "Γερμανικά",
        "localeFrench": "Γαλλικά",
        "localeSpanish": "Ισπανικά",
        "localeItalian": "Ιταλικά",
        "settingsTitle": "Ρυθμίσεις",
        "moreMenuHeadline": "Ασφάλεια, ημερολόγιο & πλήρωμα",
        "communityHubTitle": "Κοινότητα",
        "voyageMonitorTitle": "Παρακολούθηση ταξιδιού",
        "yachtHubTitle": "Κέντρο σκάφους",
        "assistantTitle": "Βοηθός καταστρώματος",
        "weatherScreenTitle": "Καιρός",
        "mapLayersSheetTitle": "Επίπεδα χάρτη",
    },
    "tr": {
        "localeGreek": "Yunanca",
        "localeTurkish": "Türkçe",
        "localePortuguese": "Portekizce",
        "languageLabel": "Dil",
        "localeEnglish": "İngilizce",
        "localeRussian": "Rusça",
        "localeGerman": "Almanca",
        "localeFrench": "Fransızca",
        "localeSpanish": "İspanyolca",
        "localeItalian": "İtalyanca",
        "settingsTitle": "Ayarlar",
        "moreMenuHeadline": "Güvenlik, günlük ve mürettebat",
        "communityHubTitle": "Topluluk",
        "voyageMonitorTitle": "Sefer izleme",
        "yachtHubTitle": "Yat merkezi",
        "assistantTitle": "Güverte asistanı",
        "weatherScreenTitle": "Hava",
        "mapLayersSheetTitle": "Harita katmanları",
    },
    "pt": {
        "localeGreek": "Grego",
        "localeTurkish": "Turco",
        "localePortuguese": "Português",
        "languageLabel": "Idioma",
        "localeEnglish": "Inglês",
        "localeRussian": "Russo",
        "localeGerman": "Alemão",
        "localeFrench": "Francês",
        "localeSpanish": "Espanhol",
        "localeItalian": "Italiano",
        "settingsTitle": "Definições",
        "moreMenuHeadline": "Segurança, diário e tripulação",
        "communityHubTitle": "Comunidade",
        "voyageMonitorTitle": "Monitor de viagem",
        "yachtHubTitle": "Hub do iate",
        "assistantTitle": "Assistente de convés",
        "weatherScreenTitle": "Meteorologia",
        "mapLayersSheetTitle": "Camadas do mapa",
    },
}

# Phase H+I strings — DE/FR/ES/IT (abbreviated set; rest falls back to EN on merge)
PHASE_HI_DE = {
    "aisScreenTitle": "AIS",
    "moreMenuCommunity": "Gemeinschaft",
    "moreMenuVoyageMonitor": "Reiseüberwachung",
    "moreMenuYachtHub": "Yacht-Hub",
    "moreMenuAssistant": "Deck-Assistent",
    "offlineChartManagerTitle": "Offline-Karten",
    "mapLayerWindOverlay": "Windpfeile",
    "settingsNotificationsSection": "Benachrichtigungen",
    "paywallTitle": "Captain Wrongel Premium",
}

PHASE_HI_FR = {
    "aisScreenTitle": "AIS",
    "moreMenuCommunity": "Communauté",
    "moreMenuVoyageMonitor": "Suivi de voyage",
    "moreMenuYachtHub": "Hub yacht",
    "moreMenuAssistant": "Assistant pont",
    "offlineChartManagerTitle": "Cartes hors ligne",
    "mapLayerWindOverlay": "Flèches de vent",
    "settingsNotificationsSection": "Notifications",
    "paywallTitle": "Captain Wrongel Premium",
}

PHASE_HI_ES = {
    "aisScreenTitle": "AIS",
    "moreMenuCommunity": "Comunidad",
    "moreMenuVoyageMonitor": "Monitor de viaje",
    "moreMenuYachtHub": "Hub del yate",
    "moreMenuAssistant": "Asistente de cubierta",
    "offlineChartManagerTitle": "Cartas offline",
    "mapLayerWindOverlay": "Flechas de viento",
    "settingsNotificationsSection": "Notificaciones",
    "paywallTitle": "Captain Wrongel Premium",
}

PHASE_HI_IT = {
    "aisScreenTitle": "AIS",
    "moreMenuCommunity": "Comunità",
    "moreMenuVoyageMonitor": "Monitoraggio viaggio",
    "moreMenuYachtHub": "Hub yacht",
    "moreMenuAssistant": "Assistente di coperta",
    "offlineChartManagerTitle": "Carte offline",
    "mapLayerWindOverlay": "Frecce del vento",
    "settingsNotificationsSection": "Notifiche",
    "paywallTitle": "Captain Wrongel Premium",
}

EXTRA = {
    "de": PHASE_HI_DE,
    "fr": PHASE_HI_FR,
    "es": PHASE_HI_ES,
    "it": PHASE_HI_IT,
}

# Primary navigation + key screens (step 56 — must not stay English).
CORE_NAV: dict[str, dict[str, str]] = {
    "de": {
        "settingsTitle": "Einstellungen",
        "tabMap": "Karte",
        "tabRoute": "Route",
        "tabWeather": "Wetter",
        "tabMooring": "Anlegen",
        "tabMore": "Mehr",
        "moreMenuCommunity": "Gemeinschaft",
        "communityHubTitle": "Gemeinschaft",
        "voyageMonitorTitle": "Reiseüberwachung",
        "errorNetwork": "Netzwerk nicht verfügbar — Verbindung prüfen und erneut versuchen.",
        "errorGpsDenied": "Standortberechtigung verweigert — in den Einstellungen aktivieren.",
        "errorGpsUnavailable": "GPS nicht verfügbar — später erneut versuchen.",
        "errorVaultDecrypt": "Tresordokument konnte nicht entschlüsselt werden — falsche PIN oder beschädigte Datei.",
        "errorRoutingFailed": "Route konnte nicht berechnet werden — Wegpunkte prüfen.",
        "errorGeneric": "Etwas ist schiefgelaufen — bitte erneut versuchen.",
        "mapLayerWindParticles": "Windpartikel",
        "mapLayerWindParticlesSubtitle": "Animiertes Strömungsfeld (pausiert im Eco-Modus / bei weniger Bewegung)",
    },
    "fr": {
        "settingsTitle": "Réglages",
        "tabMap": "Carte",
        "tabRoute": "Route",
        "tabWeather": "Météo",
        "tabMooring": "Mouillage",
        "tabMore": "Plus",
        "moreMenuCommunity": "Communauté",
        "communityHubTitle": "Communauté",
        "voyageMonitorTitle": "Suivi de voyage",
        "errorNetwork": "Réseau indisponible — vérifiez la connexion et réessayez.",
        "errorGpsDenied": "Autorisation de localisation refusée — activez-la dans les réglages.",
        "errorGpsUnavailable": "GPS indisponible — réessayez plus tard.",
        "errorVaultDecrypt": "Impossible de déchiffrer le document du coffre — mauvais code ou fichier corrompu.",
        "errorRoutingFailed": "Impossible de calculer l'itinéraire — vérifiez les points.",
        "errorGeneric": "Une erreur s'est produite — veuillez réessayer.",
        "mapLayerWindParticles": "Particules de vent",
        "mapLayerWindParticlesSubtitle": "Champ de flux animé (pause en mode éco / réduction des animations)",
    },
    "es": {
        "settingsTitle": "Ajustes",
        "tabMap": "Mapa",
        "tabRoute": "Ruta",
        "tabWeather": "Tiempo",
        "tabMooring": "Fondeo",
        "tabMore": "Más",
        "moreMenuCommunity": "Comunidad",
        "communityHubTitle": "Comunidad",
        "voyageMonitorTitle": "Monitor de viaje",
        "errorNetwork": "Red no disponible — comprueba la conexión e inténtalo de nuevo.",
        "errorGpsDenied": "Permiso de ubicación denegado — actívalo en ajustes.",
        "errorGpsUnavailable": "GPS no disponible — inténtalo más tarde.",
        "errorVaultDecrypt": "No se pudo descifrar el documento de la caja fuerte — PIN incorrecto o archivo dañado.",
        "errorRoutingFailed": "No se pudo calcular la ruta — revisa los waypoints.",
        "errorGeneric": "Algo salió mal — inténtalo de nuevo.",
        "mapLayerWindParticles": "Partículas de viento",
        "mapLayerWindParticlesSubtitle": "Campo de flujo animado (pausa en modo eco / reducir movimiento)",
    },
    "it": {
        "settingsTitle": "Impostazioni",
        "tabMap": "Mappa",
        "tabRoute": "Rotta",
        "tabWeather": "Meteo",
        "tabMooring": "Ormeggio",
        "tabMore": "Altro",
        "moreMenuCommunity": "Comunità",
        "communityHubTitle": "Comunità",
        "voyageMonitorTitle": "Monitoraggio viaggio",
        "errorNetwork": "Rete non disponibile — controlla la connessione e riprova.",
        "errorGpsDenied": "Permesso posizione negato — attivalo nelle impostazioni.",
        "errorGpsUnavailable": "GPS non disponibile — riprova più tardi.",
        "errorVaultDecrypt": "Impossibile decifrare il documento del caveau — PIN errato o file corrotto.",
        "errorRoutingFailed": "Impossibile calcolare la rotta — controlla i waypoint.",
        "errorGeneric": "Qualcosa è andato storto — riprova.",
        "mapLayerWindParticles": "Particelle del vento",
        "mapLayerWindParticlesSubtitle": "Campo di flusso animato (pausa in eco / riduci movimento)",
    },
    "el": {
        "tabMap": "Χάρτης",
        "tabRoute": "Διαδρομή",
        "tabWeather": "Καιρός",
        "tabMooring": "Αγκυροβόλιο",
        "tabMore": "Περισσότερα",
        "moreMenuCommunity": "Κοινότητα",
        "errorNetwork": "Το δίκτυο δεν είναι διαθέσιμο — ελέγξτε τη σύνδεση και δοκιμάστε ξανά.",
        "mapLayerWindParticles": "Σωματίδια ανέμου",
        "mapLayerWindParticlesSubtitle": "Κινούμενο πεδίο ροής (παύση σε eco / μείωση κίνησης)",
    },
    "tr": {
        "tabMap": "Harita",
        "tabRoute": "Rota",
        "tabWeather": "Hava",
        "tabMooring": "Demirleme",
        "tabMore": "Daha fazla",
        "moreMenuCommunity": "Topluluk",
        "errorNetwork": "Ağ kullanılamıyor — bağlantıyı kontrol edip tekrar deneyin.",
        "mapLayerWindParticles": "Rüzgar parçacıkları",
        "mapLayerWindParticlesSubtitle": "Animasyonlu akış alanı (eko / hareketi azalt modunda duraklar)",
    },
    "pt": {
        "tabMap": "Mapa",
        "tabRoute": "Rota",
        "tabWeather": "Meteorologia",
        "tabMooring": "Ancoragem",
        "tabMore": "Mais",
        "moreMenuCommunity": "Comunidade",
        "errorNetwork": "Rede indisponível — verifique a ligação e tente novamente.",
        "mapLayerWindParticles": "Partículas de vento",
        "mapLayerWindParticlesSubtitle": "Campo de fluxo animado (pausa em eco / reduzir movimento)",
    },
}


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def dump_json(path: Path, data: dict) -> None:
    path.write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def merge_template(template: dict, target: dict, overrides: dict) -> dict:
    out = deepcopy(target)
    for key, value in template.items():
        if key.startswith("@"):
            if key not in out:
                out[key] = value
            continue
        if key not in out:
            out[key] = value
    out.update(overrides)
    return out


def main() -> None:
    en = load_json(ARB_DIR / TEMPLATE)
    locales = ["de", "fr", "es", "it", "ru", "el", "tr", "pt"]

    for loc in locales:
        path = ARB_DIR / f"app_{loc}.arb"
        existing = load_json(path) if path.exists() else {}
        names = LOCALE_NAMES.get(loc, {})
        names.update(LOCALE_NAMES.get("en", {}))
        names.update(EXTRA.get(loc, {}))
        names.update(CORE_NAV.get(loc, {}))
        if loc in ("el", "tr", "pt") and not existing:
            existing = {}
        merged = merge_template(en, existing, names)
        merged["@@locale"] = loc
        dump_json(path, merged)
        print(f"Wrote {path.name} ({len([k for k in merged if not k.startswith('@')])} keys)")


if __name__ == "__main__":
    main()
