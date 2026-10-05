## UIFactory — Centralized UI construction following DGLabs standards.
## Rule: StyleBoxFlat ALWAYS (corner radius min(w,h)*0.28), bare icons 85%,
## X close button top-right 56×56 round dark red, AUTOWRAP_WORD_SMART.
class_name UIFactory
extends RefCounted

# --- Color palette (Far West cantina) ---
const CANTINA_WOOD_DARK := Color(0.35, 0.22, 0.12)
const CANTINA_WOOD_LIGHT := Color(0.55, 0.36, 0.18)
const CANTINA_RED := Color(0.55, 0.0, 0.0)
const CANTINA_GOLD := Color(0.85, 0.65, 0.13)
const CANTINA_GREEN := Color(0.0, 0.39, 0.0)
const CANTINA_BLUE := Color(0.25, 0.42, 0.91)
const UI_BG := Color(0.18, 0.14, 0.10)
const UI_TEXT := Color(0.95, 0.92, 0.85)
const UI_TEXT_DARK := Color(0.2, 0.15, 0.1)
const TOGGLE_ON := Color(0.2, 0.7, 0.3)
const TOGGLE_OFF := Color(0.7, 0.2, 0.2)
const CLOSE_BTN_RED := Color(0.72, 0.11, 0.11)


static func make_stylebox(bg_color: Color, corner_radius: float, border_color: Color = Color.TRANSPARENT, border_width: float = 0.0) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg_color
	sb.set_corner_radius_all(int(corner_radius))
	if border_width > 0:
		sb.border_color = border_color
		sb.set_border_width_all(int(border_width))
	return sb


static func make_panel_style(size: Vector2) -> StyleBoxFlat:
	var radius: float = minf(size.x, size.y) * 0.28
	return make_stylebox(UI_BG, radius, CANTINA_GOLD, 2.0)


static func make_button(text: String, size: Vector2) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = size
	var radius: float = minf(size.x, size.y) * 0.28
	btn.add_theme_stylebox_override("normal", make_stylebox(CANTINA_WOOD_LIGHT, radius, CANTINA_GOLD, 2.0))
	btn.add_theme_stylebox_override("hover", make_stylebox(CANTINA_GOLD, radius))
	btn.add_theme_stylebox_override("pressed", make_stylebox(CANTINA_WOOD_DARK, radius))
	btn.add_theme_color_override("font_color", UI_TEXT)
	btn.add_theme_color_override("font_hover_color", UI_TEXT_DARK)
	btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return btn


static func make_close_button(size: Vector2 = Vector2(56, 56)) -> Button:
	var btn := Button.new()
	btn.text = "X"
	btn.custom_minimum_size = size
	btn.size = size
	var radius: float = minf(size.x, size.y) * 0.28
	btn.add_theme_stylebox_override("normal", make_stylebox(CLOSE_BTN_RED, radius))
	btn.add_theme_stylebox_override("hover", make_stylebox(Color(0.85, 0.15, 0.15), radius))
	btn.add_theme_stylebox_override("pressed", make_stylebox(Color(0.6, 0.08, 0.08), radius))
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_font_size_override("font_size", int(size.x * 0.4))
	return btn


static func make_label(text: String, font_size: int = 16, color: Color = UI_TEXT) -> Label:
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", font_size)
	lbl.add_theme_color_override("font_color", color)
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return lbl


static func make_toggle(initial: bool) -> CheckButton:
	var toggle := CheckButton.new()
	toggle.button_pressed = initial
	_update_toggle_style(toggle)
	toggle.toggled.connect(func(pressed: bool) -> void: _update_toggle_style(toggle))
	return toggle


static func _update_toggle_style(toggle: CheckButton) -> void:
	var color: Color = TOGGLE_ON if toggle.button_pressed else TOGGLE_OFF
	toggle.add_theme_color_override("font_color", color)
