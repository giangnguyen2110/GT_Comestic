using Microsoft.AspNetCore.Mvc;
using System.Linq;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.Models;
namespace WebActionResults_1923051154.Controllers
{
    public class SupplierController : Controller
    {
        private readonly GtEcommerceContext _context;
        public SupplierController(GtEcommerceContext context)
        {
            _context = context;
        }
        public IActionResult Index()
        {
            var data = _context.Suppliers.ToList();
            return View(data);
        }

        public IActionResult Create()
        {
            var nextId = _context.Suppliers
            .OrderByDescending(s => s.Id)
            .Select(s => s.Id)
            .FirstOrDefault() + 1;

            ViewBag.NextId = nextId;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(Supplier s)
        {
            if (ModelState.IsValid)
            {
                _context.Suppliers.Add(s);
                _context.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(s);
        }

        public IActionResult Edit(int id)
        {
            var s = _context.Suppliers.Find(id);
            if (s == null)
            {
                return NotFound();
            }
            return View(s);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, Supplier s)
        {
            if (id != s.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                _context.Suppliers.Update(s);
                _context.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(s);
        }

        public IActionResult Delete(int id)
        {
            var s = _context.Suppliers.Find(id);
            return View(s);
        }


        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteConfirmed(int id)
        {
            var s = _context.Suppliers.Find(id);

            if (s != null)
            {
                _context.Suppliers.Remove(s);
                _context.SaveChanges();
            }

            return RedirectToAction("Index");
        }
    }
}
