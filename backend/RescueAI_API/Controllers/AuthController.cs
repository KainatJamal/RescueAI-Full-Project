using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RescueAI_API.Data;
using RescueAI_API.Models;
using RescueAI_API.DTOs;

namespace RescueAI_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AuthController(AppDbContext context)
        {
            _context = context;
        }

        // =========================
        // SIGNUP
        // =========================
        [HttpPost("signup")]
        public async Task<IActionResult> Signup(RegisterDto request)
        {
            if (await _context.Users.AnyAsync(u => u.Email == request.Email))
                return BadRequest("Email already exists");

            string hashedPassword = BCrypt.Net.BCrypt.HashPassword(request.Password);

            var newUser = new User
            {
                Email = request.Email,
                PasswordHash = hashedPassword
            };

            _context.Users.Add(newUser);
            await _context.SaveChangesAsync();

            return Ok("User created successfully");
        }

        // =========================
        // LOGIN
        // =========================
        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginDto request)
        {
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Email == request.Email);

            if (user == null)
                return Unauthorized("Invalid credentials");

            bool isPasswordValid =
                BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash);

            if (!isPasswordValid)
                return Unauthorized("Invalid credentials");

            return Ok("Login successful");
        }
    }
}