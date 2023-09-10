var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddSwaggerGen();
var app = builder.Build();

app.UseStaticFiles();
app.MapFallbackToFile("index.html");
app.MapControllers();
app.Run();