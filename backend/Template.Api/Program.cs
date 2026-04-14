using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.EntityFrameworkCore;
using Template.Application.Common.Interfaces;
using Template.Infrastructure.Persistence;
using Template.Infrastructure.Services;
using Template.Application.Middlewares;
using Template.Application.Features.Auth;
using Template.Application.Common.Configurations;
using FluentValidation;
using FluentValidation.AspNetCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Extensions.Configuration;
using System.Text;
using System.Reflection;

var builder = WebApplication.CreateBuilder(args);
var configuration = builder.Configuration;

// Add services to the container.
builder.Services.AddControllers();

// Register DbContext with InMemory database since we don't want Migrations.
builder.Services.AddDbContext<IAppDbContext, AppDbContext>(options =>
    options.UseInMemoryDatabase("TemplateDb"));

// Get Application assembly
var applicationAssembly = typeof(CreateUserCommand).Assembly;

// Register MediatR
builder.Services.AddMediatR(config =>
    config.RegisterServicesFromAssembly(applicationAssembly));

// Register FluentValidation
builder.Services.AddValidatorsFromAssembly(applicationAssembly);
builder.Services.AddFluentValidationAutoValidation();

// JWT Configuration
var jwtSection = configuration.GetSection(JwtOptions.SectionName);
builder.Services.Configure<JwtOptions>(jwtSection);
var jwtOptions = jwtSection.Get<JwtOptions>() ?? new JwtOptions();

builder.Services.AddSingleton<IJwtTokenGenerator, JwtTokenGenerator>();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtOptions.Issuer,
            ValidAudience = jwtOptions.Audience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtOptions.Secret))
        };
    });
builder.Services.AddAuthorization();

// Register the Error Handling Middleware
builder.Services.AddScoped<ErrorHandlingMiddleware>();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

// Put the error handling middleware early in the pipeline
app.UseMiddleware<ErrorHandlingMiddleware>();

app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
