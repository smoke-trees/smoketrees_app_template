import 'package:json_annotation/json_annotation.dart';

/// A Stac representation of Flutter's [Curves] collection.
///
/// Maps a JSON-friendly curve name to the corresponding [Curve] constant,
/// for use anywhere Stac needs to describe an animation easing curve (e.g.
/// [StDialog.insetAnimationCurve], implicit animations, page transitions).
///
/// ```json
/// { "type": "dialog", "insetAnimationCurve": "easeInOutCubic", "child": { ... } }
/// ```
///
/// See also:
///  * Flutter's [Curves documentation](https://api.flutter.dev/flutter/animation/Curves-class.html)
@JsonEnum()
enum StCurves {
  /// An oscillating curve that grows in magnitude.
  bounceIn,

  /// An oscillating curve that first grows and then shrinks in magnitude.
  bounceInOut,

  /// An oscillating curve that first grows and then shrinks in magnitude.
  bounceOut,

  /// A curve where the rate of change starts out quickly and then
  /// decelerates; an upside-down `f(t) = t²` parabola.
  decelerate,

  /// A cubic animation curve that speeds up quickly and ends slowly.
  ease,

  /// A cubic animation curve that starts slowly and ends quickly.
  easeIn,

  /// Similar to [elasticIn]; overshoots its bounds once before ascending.
  easeInBack,

  /// Starts slowly and ends quickly; the bottom-right quarter of a circle.
  easeInCirc,

  /// Starts slowly and ends quickly, based on `f(t) = t³`.
  easeInCubic,

  /// Starts slowly and ends quickly, based on `f(t) = 2^(10(t-1))`.
  easeInExpo,

  /// Starts slowly, speeds up, and then ends slowly.
  easeInOut,

  /// [easeInBack] as the first half, [easeOutBack] as the second.
  easeInOutBack,

  /// [easeInCirc] as the first half, [easeOutCirc] as the second.
  easeInOutCirc,

  /// [easeInCubic] as the first half, [easeOutCubic] as the second.
  easeInOutCubic,

  /// A steeper version of [easeInOutCubic]; starts slowly, speeds up
  /// shortly after, then ends slowly.
  easeInOutCubicEmphasized,

  /// Starts slowly, speeds up, and then ends slowly (exponential).
  easeInOutExpo,

  /// [easeInQuad] as the first half, [easeOutQuad] as the second.
  easeInOutQuad,

  /// [easeInQuart] as the first half, [easeOutQuart] as the second.
  easeInOutQuart,

  /// [easeInQuint] as the first half, [easeOutQuint] as the second.
  easeInOutQuint,

  /// Similar to [easeInOut], but with sinusoidal easing.
  easeInOutSine,

  /// Starts slowly and ends quickly, based on `f(t) = t²`. The inverse of
  /// [decelerate].
  easeInQuad,

  /// Starts slowly and ends quickly, based on `f(t) = t⁴`.
  easeInQuart,

  /// Starts slowly and ends quickly, based on `f(t) = t⁵`.
  easeInQuint,

  /// Similar to [easeIn], but with sinusoidal easing; gentle, close to
  /// [linear].
  easeInSine,

  /// Starts slowly and ends linearly.
  easeInToLinear,

  /// A cubic animation curve that starts quickly and ends slowly.
  easeOut,

  /// Similar to [elasticOut]; overshoots its bounds once after ascending.
  easeOutBack,

  /// Starts quickly and ends slowly; the top-left quarter of a circle.
  easeOutCirc,

  /// A flipped version of [easeInCubic].
  easeOutCubic,

  /// A flipped version of [easeInExpo].
  easeOutExpo,

  /// Effectively the same as [decelerate], simulated with a cubic bezier.
  easeOutQuad,

  /// A flipped version of [easeInQuart].
  easeOutQuart,

  /// A flipped version of [easeInQuint].
  easeOutQuint,

  /// Similar to [easeOut], but with sinusoidal easing; gentle, close to
  /// [linear].
  easeOutSine,

  /// An oscillating curve that grows in magnitude while overshooting its
  /// bounds.
  elasticIn,

  /// An oscillating curve that grows and then shrinks in magnitude while
  /// overshooting its bounds.
  elasticInOut,

  /// An oscillating curve that shrinks in magnitude while overshooting its
  /// bounds.
  elasticOut,

  /// Starts slowly, speeds up very quickly, and then ends slowly.
  fastEaseInToSlowEaseOut,

  /// Very steep and linear at the beginning, then quickly flattens out and
  /// very slowly eases in.
  fastLinearToSlowEaseIn,

  /// A curve that starts quickly and eases into its final position.
  fastOutSlowIn,

  /// The identity map over the unit interval — a linear animation curve.
  linear,

  /// Starts linearly and ends slowly.
  linearToEaseOut,

  /// Starts quickly, slows down, and then ends quickly.
  slowMiddle,
}