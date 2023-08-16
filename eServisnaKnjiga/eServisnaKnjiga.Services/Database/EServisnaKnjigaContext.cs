using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace eServisnaKnjiga.Services.Database;

public partial class EServisnaKnjigaContext : DbContext
{
    public EServisnaKnjigaContext()
    {
    }

    public EServisnaKnjigaContext(DbContextOptions<EServisnaKnjigaContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Automobil> Automobils { get; set; }

    public virtual DbSet<Klijent> Klijents { get; set; }

    public virtual DbSet<Korisnici> Korisnicis { get; set; }

    public virtual DbSet<Majstori> Majstoris { get; set; }

    public virtual DbSet<Novosti> Novostis { get; set; }

    public virtual DbSet<Obavjesti> Obavjestis { get; set; }

    public virtual DbSet<Paketi> Paketis { get; set; }

    public virtual DbSet<RadniNalog> RadniNalogs { get; set; }

    public virtual DbSet<Rezervacije> Rezervacijes { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=localhost, 1434;Initial Catalog=eServisnaKnjiga; user=sa; password=dSifraB!95; TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Automobil>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Automobi__3213E83F2DBC7F03");

            entity.ToTable("Automobil");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.BrojSasije)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("broj_sasije");
            entity.Property(e => e.GodinaProizvodnje).HasColumnName("godina_proizvodnje");
            entity.Property(e => e.KlijentId).HasColumnName("klijent_id");
            entity.Property(e => e.Marka)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("marka");
            entity.Property(e => e.Model)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("model");
            entity.Property(e => e.Registracija)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("registracija");

            entity.HasOne(d => d.Klijent).WithMany(p => p.Automobils)
                .HasForeignKey(d => d.KlijentId)
                .HasConstraintName("FK__Automobil__klije__3E52440B");
        });

        modelBuilder.Entity<Klijent>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Klijent__3213E83FE245D546");

            entity.ToTable("Klijent");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.Adresa)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("adresa");
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("email");
            entity.Property(e => e.Ime)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("ime");
            entity.Property(e => e.Prezime)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("prezime");
            entity.Property(e => e.Telefon)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("telefon");
        });

        modelBuilder.Entity<Korisnici>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Korisnic__3213E83FB5671C9A");

            entity.ToTable("Korisnici");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("email");
            entity.Property(e => e.KlijentId).HasColumnName("klijent_id");
            entity.Property(e => e.Lozinka)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("lozinka");
            entity.Property(e => e.RoleId).HasColumnName("role_id");

            entity.HasOne(d => d.Klijent).WithMany(p => p.Korisnicis)
                .HasForeignKey(d => d.KlijentId)
                .HasConstraintName("FK__Korisnici__klije__4316F928");

            entity.HasOne(d => d.Role).WithMany(p => p.Korisnicis)
                .HasForeignKey(d => d.RoleId)
                .HasConstraintName("FK__Korisnici__role___440B1D61");
        });

        modelBuilder.Entity<Majstori>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Majstori__3213E83F6263AA81");

            entity.ToTable("Majstori");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.DatumRodjenja)
                .HasColumnType("date")
                .HasColumnName("datum_rodjenja");
            entity.Property(e => e.Ime)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("ime");
            entity.Property(e => e.Prezime)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("prezime");
        });

        modelBuilder.Entity<Novosti>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Novosti__3213E83F1DF58AA0");

            entity.ToTable("Novosti");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.DatumObjave)
                .HasColumnType("date")
                .HasColumnName("datum_objave");
            entity.Property(e => e.Naslov)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("naslov");
            entity.Property(e => e.Tekst)
                .IsUnicode(false)
                .HasColumnName("tekst");
        });

        modelBuilder.Entity<Obavjesti>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Obavjest__3213E83F80CABB24");

            entity.ToTable("Obavjesti");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.Datum)
                .HasColumnType("date")
                .HasColumnName("datum");
            entity.Property(e => e.KorisnikId).HasColumnName("korisnik_id");
            entity.Property(e => e.PaketId).HasColumnName("paket_id");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Obavjestis)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Obavjesti__koris__5165187F");

            entity.HasOne(d => d.Paket).WithMany(p => p.Obavjestis)
                .HasForeignKey(d => d.PaketId)
                .HasConstraintName("FK__Obavjesti__paket__52593CB8");
        });

        modelBuilder.Entity<Paketi>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Paketi__3213E83F45ACD259");

            entity.ToTable("Paketi");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.IntervalObavjesti)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("interval_obavjesti");
            entity.Property(e => e.MaksimalnaCijena)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("maksimalna_cijena");
            entity.Property(e => e.MinimalnaCijena)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("minimalna_cijena");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("naziv");
            entity.Property(e => e.Opis)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("opis");
        });

        modelBuilder.Entity<RadniNalog>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__RadniNal__3213E83FA49EA8CC");

            entity.ToTable("RadniNalog");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.Cijena)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("cijena");
            entity.Property(e => e.Datum)
                .HasColumnType("date")
                .HasColumnName("datum");
            entity.Property(e => e.MajstorId).HasColumnName("majstor_id");
            entity.Property(e => e.Opis)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("opis");
            entity.Property(e => e.RezervacijaId).HasColumnName("rezervacija_id");

            entity.HasOne(d => d.Majstor).WithMany(p => p.RadniNalogs)
                .HasForeignKey(d => d.MajstorId)
                .HasConstraintName("FK__RadniNalo__majst__5BE2A6F2");

            entity.HasOne(d => d.Rezervacija).WithMany(p => p.RadniNalogs)
                .HasForeignKey(d => d.RezervacijaId)
                .HasConstraintName("FK__RadniNalo__rezer__5CD6CB2B");
        });

        modelBuilder.Entity<Rezervacije>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Rezervac__3213E83F240996C5");

            entity.ToTable("Rezervacije");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.AutomobilId).HasColumnName("automobil_id");
            entity.Property(e => e.Datum)
                .HasColumnType("date")
                .HasColumnName("datum");
            entity.Property(e => e.Opis)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("opis");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("status");

            entity.HasOne(d => d.Automobil).WithMany(p => p.Rezervacijes)
                .HasForeignKey(d => d.AutomobilId)
                .HasConstraintName("FK__Rezervaci__autom__59063A47");

            entity.HasMany(d => d.Pakets).WithMany(p => p.Rezervacijas)
                .UsingEntity<Dictionary<string, object>>(
                    "RezervacijaPaketi",
                    r => r.HasOne<Paketi>().WithMany()
                        .HasForeignKey("PaketId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Rezervaci__paket__5FB337D6"),
                    l => l.HasOne<Rezervacije>().WithMany()
                        .HasForeignKey("RezervacijaId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Rezervaci__rezer__60A75C0F"),
                    j =>
                    {
                        j.HasKey("RezervacijaId", "PaketId").HasName("PK__Rezervac__FAC8F1E75C2A2155");
                        j.ToTable("Rezervacija_Paketi");
                        j.IndexerProperty<int>("RezervacijaId").HasColumnName("rezervacija_id");
                        j.IndexerProperty<int>("PaketId").HasColumnName("paket_id");
                    });
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Role__3213E83F03ADC802");

            entity.ToTable("Role");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("naziv");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
