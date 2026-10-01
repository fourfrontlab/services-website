import { Link } from "react-router-dom";
import "./interactive-hero.css";

/**
 * Interactive Hero — Syed Photography & Videography banner.
 *
 * Banner image: 1376 × 768 px  (verified via System.Drawing)
 *
 * SVG viewBox="0 0 1376 768" — coordinate system is IDENTICAL to
 * the source image pixels, so rects cannot drift at any screen width.
 *
 * Card pixel boundaries measured by scanning x=702 (left border column)
 * and x=1295 (right border column) of the actual JPEG:
 *
 *   TOP-LEFT  (SEO):        x=697,  y=109, w=287, h=262
 *   TOP-RIGHT (Digital Mkt): x=1013, y=109, w=287, h=262
 *   BOT-LEFT  (Visual):     x=697,  y=398, w=287, h=254
 *   BOT-RIGHT (Branding):   x=1013, y=398, w=287, h=254
 *
 * Gap between left/right columns: x=984 to x=1013 (cream strip ~29px)
 * Gap between top/bottom rows:    y=371 to y=397 (cream strip ~27px)
 *
 * Cards DO have visible gaps between them — they are NOT a joined grid.
 */
export default function InteractiveHero() {
  return (
    <section className="interactive-hero" aria-label="Agency services hero">
      <div className="interactive-banner">
        {/* The image is the ONLY layout driver — SVG sits flush on top */}
        <img
          src="/assets/aster-main-banner.jpg"
          alt="Syed Photography & Videography – Full-Service Digital Agency"
          className="banner-image"
          width={1376}
          height={768}
          draggable={false}
        />

        {/*
         * SVG overlay:
         *   viewBox matches image pixel dimensions exactly.
         *   preserveAspectRatio="xMidYMid meet" mirrors how the browser
         *   scales a width:100%;height:auto image — same scaling factor,
         *   same coordinate origin, zero drift.
         *   position:absolute;inset:0 pins it flush with the image.
         */}
        <svg
          className="banner-hotspots"
          viewBox="0 0 1376 768"
          preserveAspectRatio="xMidYMid meet"
          aria-hidden="true"
          focusable="false"
        >
          {/* ── SEO & Content Strategy (top-left) ────────────────── */}
          {/* x=697, y=109, w=287, h=262 */}
          <Link to="/services?category=web-design-and-development" aria-label="SEO & Content Strategy">
            <rect
              className="card-hitbox"
              x="697"
              y="109"
              width="287"
              height="262"
              rx="14"
              ry="14"
            />
          </Link>

          {/* ── Digital Marketing (top-right) ─────────────────────── */}
          {/* x=1013, y=109, w=287, h=262 */}
          <Link to="/services?category=brand-and-content" aria-label="Digital Marketing">
            <rect
              className="card-hitbox"
              x="1013"
              y="109"
              width="287"
              height="262"
              rx="14"
              ry="14"
            />
          </Link>

          {/* ── Visual Media (bottom-left) ───────────────────────── */}
          {/* x=697, y=398, w=287, h=254 */}
          <Link to="/services?category=videography-and-photography" aria-label="Visual Media">
            <rect
              className="card-hitbox"
              x="697"
              y="398"
              width="287"
              height="254"
              rx="14"
              ry="14"
            />
          </Link>

          {/* ── Branding & Visual Identity (bottom-right) ─────────── */}
          {/* x=1013, y=398, w=287, h=254 */}
          <Link to="/services?category=brand-and-content" aria-label="Branding & Visual Identity">
            <rect
              className="card-hitbox"
              x="1013"
              y="398"
              width="287"
              height="254"
              rx="14"
              ry="14"
            />
          </Link>

          {/* ── Explore All Services button ───────────────────────── */}
          {/* Button visible at roughly x=544, y=718, w=287 — with padding */}
          <Link to="/services" aria-label="Explore All Services">
            <rect
              className="card-hitbox explore-hitbox"
              x="544"
              y="710"
              width="287"
              height="38"
              rx="19"
              ry="19"
            />
          </Link>
        </svg>
      </div>
    </section>
  );
}
