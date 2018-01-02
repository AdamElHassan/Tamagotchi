using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TamagotchiHotel.Models;
using TamagotchiHotel.ViewModels;

namespace TamagotchiHotel.Controllers
{
    public class BoekingsController : Controller
    {
        private TamagotchiHotelEntities db = new TamagotchiHotelEntities();

        // GET: Boekings
        public ActionResult Index()
        {
            BoekingViewModel boeking = new BoekingViewModel();

            boeking.Kamer = db.HotelKamer.Where(k => k.Tamagotchi.Count <= 0).ToList();
            boeking.Tamagotchi = db.Tamagotchi.Where(t => t.Dood == false).ToList();

            return View(boeking);
        }


    }
}