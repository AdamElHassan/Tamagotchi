using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using TamagotchiHotel.Models;

namespace TamagotchiHotel.Controllers
{
    public class TamagotchisController : Controller
    {
        private TamagotchiHotelEntities db = new TamagotchiHotelEntities();

        // GET: Tamagotchis
        public ActionResult Index()
        {
            var tamagotchi = db.Tamagotchi.Include(t => t.HotelKamer);
            return View(tamagotchi.ToList());
        }

        // GET: Tamagotchis/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Tamagotchi tamagotchi = db.Tamagotchi.Find(id);
            if (tamagotchi == null)
            {
                return HttpNotFound();
            }
            return View(tamagotchi);
        }

        // GET: Tamagotchis/Create
        public ActionResult Create()
        {
            ViewBag.HotelKamerID = new SelectList(db.HotelKamer, "Id", "KamerType");
            return View();
        }

        // POST: Tamagotchis/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,HotelKamerID,Naam,Kleur,Leeftijd,Centjes,Level,Gezondheid,Verveling,Dood")] Tamagotchi tamagotchi)
        {
            if (ModelState.IsValid)
            {
               
                    var tamagotchis = db.Tamagotchi.FirstOrDefault();
                    if (tamagotchis != null)
                    {
                        int newIndex = db.Tamagotchi.Max(p => p.Id);
                        tamagotchi.Id = newIndex + 1;
                    }
                    else
                    {
                        tamagotchi.Id = 0;
                    }

                    tamagotchi.Level = 0;
                    tamagotchi.Leeftijd = 0;
                    tamagotchi.Verveling = 0;
                    tamagotchi.Dood = false;
                    tamagotchi.Gezondheid = 100;
                    tamagotchi.Centjes = 100;
                    db.Tamagotchi.Add(tamagotchi);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            
            ViewBag.HotelKamerID = new SelectList(db.HotelKamer, "Id", "KamerType", tamagotchi.HotelKamerID);
            return View(tamagotchi);
        }

        // GET: Tamagotchis/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Tamagotchi tamagotchi = db.Tamagotchi.Find(id);
            if (tamagotchi == null)
            {
                return HttpNotFound();
            }
            ViewBag.HotelKamerID = new SelectList(db.HotelKamer, "Id", "KamerType", tamagotchi.HotelKamerID);
            return View(tamagotchi);
        }

        // POST: Tamagotchis/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,HotelKamerID,Naam,Kleur,Leeftijd,Centjes,Level,Gezondheid,Verveling,Dood")] Tamagotchi tamagotchi)
        {
            if (ModelState.IsValid)
            {
                db.Entry(tamagotchi).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.HotelKamerID = new SelectList(db.HotelKamer, "Id", "KamerType", tamagotchi.HotelKamerID);
            return View(tamagotchi);
        }

        // GET: Tamagotchis/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Tamagotchi tamagotchi = db.Tamagotchi.Find(id);
            if (tamagotchi == null)
            {
                return HttpNotFound();
            }
            return View(tamagotchi);
        }

        // POST: Tamagotchis/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Tamagotchi tamagotchi = db.Tamagotchi.Find(id);
            db.Tamagotchi.Remove(tamagotchi);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
