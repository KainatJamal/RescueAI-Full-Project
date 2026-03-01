namespace RescueAI_API.Data
{
    using Microsoft.EntityFrameworkCore;
    using RescueAI_API.Models;

    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options) { }

        public DbSet<User> Users { get; set; }
    }
}
