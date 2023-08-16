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

    public virtual DbSet<RezervacijaPaketi> RezervacijaPaketis { get; set; }

    public virtual DbSet<Rezervacije> Rezervacijes { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=localhost, 1434;Initial Catalog=eServisnaKnjiga; user=sa; password=dSifraB!95; TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Automobil>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Automobi__3213E83FA92C638F");

            entity.ToTable("Automobil");

            entity.Property(e => e.Id).HasColumnName("id");
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
                .HasConstraintName("FK__Automobil__klije__76969D2E");
        });

        modelBuilder.Entity<Klijent>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Klijent__3213E83F3B8FE3CE");

            entity.ToTable("Klijent");

            entity.Property(e => e.Id).HasColumnName("id");
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
            entity.HasKey(e => e.Id).HasName("PK__Korisnic__3213E83FCF69A1F7");

            entity.ToTable("Korisnici");

            entity.Property(e => e.Id).HasColumnName("id");
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
                .HasConstraintName("FK__Korisnici__klije__7F2BE32F");

            entity.HasOne(d => d.Role).WithMany(p => p.Korisnicis)
                .HasForeignKey(d => d.RoleId)
                .HasConstraintName("FK__Korisnici__role___00200768");
        });

        modelBuilder.Entity<Majstori>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Majstori__3213E83FF987DA26");

            entity.ToTable("Majstori");

            entity.Property(e => e.Id).HasColumnName("id");
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
            entity.HasKey(e => e.Id).HasName("PK__Novosti__3213E83F9F55FF85");

            entity.ToTable("Novosti");

            entity.Property(e => e.Id).HasColumnName("id");
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
            entity.HasKey(e => e.Id).HasName("PK__Obavjest__3213E83F87759CA9");

            entity.ToTable("Obavjesti");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Datum)
                .HasColumnType("date")
                .HasColumnName("datum");
            entity.Property(e => e.KorisnikId).HasColumnName("korisnik_id");
            entity.Property(e => e.PaketId).HasColumnName("paket_id");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Obavjestis)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Obavjesti__koris__10566F31");

            entity.HasOne(d => d.Paket).WithMany(p => p.Obavjestis)
                .HasForeignKey(d => d.PaketId)
                .HasConstraintName("FK__Obavjesti__paket__114A936A");
        });

        modelBuilder.Entity<Paketi>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Paketi__3213E83F82502657");

            entity.ToTable("Paketi");

            entity.Property(e => e.Id).HasColumnName("id");
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
            entity.HasKey(e => e.Id).HasName("PK__RadniNal__3213E83F4F68FAB9");

            entity.ToTable("RadniNalog");

            entity.Property(e => e.Id).HasColumnName("id");
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
                .HasConstraintName("FK__RadniNalo__majst__1AD3FDA4");

            entity.HasOne(d => d.Rezervacija).WithMany(p => p.RadniNalogs)
                .HasForeignKey(d => d.RezervacijaId)
                .HasConstraintName("FK__RadniNalo__rezer__1BC821DD");
        });

        modelBuilder.Entity<RezervacijaPaketi>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Rezervac__3213E83FCDD2A378");

            entity.ToTable("Rezervacija_Paketi");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.PaketId).HasColumnName("paket_id");
            entity.Property(e => e.RezervacijaId).HasColumnName("rezervacija_id");

            entity.HasOne(d => d.Paket).WithMany(p => p.RezervacijaPaketis)
                .HasForeignKey(d => d.PaketId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Rezervaci__paket__1EA48E88");

            entity.HasOne(d => d.Rezervacija).WithMany(p => p.RezervacijaPaketis)
                .HasForeignKey(d => d.RezervacijaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Rezervaci__rezer__1F98B2C1");
        });

        modelBuilder.Entity<Rezervacije>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Rezervac__3213E83F896D2872");

            entity.ToTable("Rezervacije");

            entity.Property(e => e.Id).HasColumnName("id");
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
                .HasConstraintName("FK__Rezervaci__autom__17F790F9");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Role__3213E83F658D240A");

            entity.ToTable("Role");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("naziv");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
